#!/bin/bash
#
# Synology DSM development-shell setup.
#
# Turns a stock Synology NAS with Entware pre-installed into a usable interactive
# shell environment: zsh + antidote + fast-syntax-highlighting + p10k, backed by
# opkg-installed git/less/tmux/nano and the shared dotfiles repo.
#
# Not intended to be a full dev machine: no brew, no ansible, no asdf, no
# language runtimes. Just the shell UX the NAS needs to be pleasant over SSH.
#
# Prerequisites:
#   - DSM 7.x with SSH enabled
#   - Entware installed (see: https://github.com/Entware/Entware/wiki)
#   - The invoking user is in the `administrators` group (for sudo)
#
# Idempotent: safe to re-run to reconcile drift.

set -euo pipefail

DOTFILES_REPO="https://github.com/btukus/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
ZDOTDIR="$HOME/dotfiles/zsh"
OPKG=/opt/bin/opkg
PROFILE_MARKER="# >>> dotfiles/install-nas.sh: auto-exec zsh >>>"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx \033[0m %s\n' "$*" >&2; exit 1; }

# --- preflight ---------------------------------------------------------------

[[ -x "$OPKG" ]] || die "Entware not found at $OPKG. Install Entware first."

# Cache sudo up front and keep it alive for the length of the run.
if [ -t 0 ]; then
    sudo -v
    ( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
    SUDO_PID=$!
    trap 'kill "$SUDO_PID" 2>/dev/null || true' EXIT
fi

# --- 1. opkg packages --------------------------------------------------------

log "opkg update"
sudo "$OPKG" update >/dev/null

log "opkg install (from nas/opkg-packages.txt)"
# Resolve script dir even before the repo is cloned, so we can read the package
# list either from a local checkout or from a curl|bash-created temp copy.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE="$SCRIPT_DIR/nas/opkg-packages.txt"
if [[ ! -f "$PKG_FILE" ]]; then
    # Fallback if this script was piped in without the repo alongside it.
    PKG_FILE="$(mktemp)"
    curl -fsSL "https://raw.githubusercontent.com/btukus/dotfiles/main/nas/opkg-packages.txt" -o "$PKG_FILE"
fi
# shellcheck disable=SC2046
sudo "$OPKG" install $(grep -v '^\s*#' "$PKG_FILE" | grep -v '^\s*$') || \
    warn "some opkg packages failed to install (continuing)"

# Everything under /opt from this point on:
export PATH="/opt/bin:/opt/sbin:$PATH"

# --- 2. dotfiles repo --------------------------------------------------------

if ! git -C "$DOTFILES_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    if [[ -e "$DOTFILES_DIR" ]]; then
        die "$DOTFILES_DIR exists but is not a git repo (interrupted clone?). Move it aside and re-run."
    fi
    log "cloning dotfiles -> $DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# --- 3. antidote (no brew on NAS, so clone directly) ------------------------

ANTIDOTE_DIR="$ZDOTDIR/antidote/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
    log "cloning antidote -> $ANTIDOTE_DIR"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

# --- 4. tmux plugin manager (matches tmux ansible role) ---------------------

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    log "cloning tpm -> $TPM_DIR"
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# --- 4b. static prebuilt binaries not in Entware (~/.local/bin, no sudo) ----
# These tools are referenced by aliases and functions in zsh/functions/*.zsh
# (e.g. `lg` uses eza, `ff` uses fzf + bat). They're not in the opkg feed, so
# grab the upstream musl/linux release binaries and drop them next to the user's
# other local bins.

mkdir -p "$HOME/.local/bin"

fetch_gh_bin() {
    # Fetch a single binary from a github release archive.
    #   $1 repo (e.g. eza-community/eza)
    #   $2 asset URL template — {VER} is substituted with the latest tag,
    #      {VER_BARE} with the tag minus a leading "v"
    #   $3 destination binary name under ~/.local/bin
    #   $4 archive-relative path to the binary inside the tarball (default: $3)
    local repo=$1 tmpl=$2 name=$3 in_archive=${4:-$3}
    local dst="$HOME/.local/bin/$name"
    if [[ -x "$dst" ]]; then
        return
    fi
    local ver
    ver=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
          | grep -o '"tag_name": "[^"]*"' | head -1 | sed 's/.*: "\(.*\)".*/\1/')
    if [[ -z "$ver" ]]; then
        warn "could not detect latest $name from $repo (rate-limited?)"
        return 1
    fi
    local url=${tmpl//\{VER\}/$ver}
    url=${url//\{VER_BARE\}/${ver#v}}
    log "installing $name $ver -> $dst"
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL "$url" | tar -xz -C "$tmp"
    # in_archive may be nested (e.g. "bat-vX.Y.Z-.../bat"); accept a glob so
    # we don't have to know the version-stamped folder up front.
    local found
    found=$(find "$tmp" -type f -name "${in_archive##*/}" -print -quit)
    [[ -z "$found" ]] && { warn "$name binary not found in archive"; rm -rf "$tmp"; return 1; }
    install -m 0755 "$found" "$dst"
    rm -rf "$tmp"
}

fetch_gh_bin eza-community/eza \
    "https://github.com/eza-community/eza/releases/download/{VER}/eza_x86_64-unknown-linux-musl.tar.gz" \
    eza
fetch_gh_bin junegunn/fzf \
    "https://github.com/junegunn/fzf/releases/download/{VER}/fzf-{VER_BARE}-linux_amd64.tar.gz" \
    fzf
fetch_gh_bin sharkdp/bat \
    "https://github.com/sharkdp/bat/releases/download/{VER}/bat-{VER}-x86_64-unknown-linux-musl.tar.gz" \
    bat

# --- 4c. asdf + language toolchains -----------------------------------------
# asdf is the shared version manager used across macOS/Linux/NAS. On the NAS
# we use it only for tools that ship prebuilt binaries fast (deno). Rust
# nightly comes via rustup instead — compiling rustc via asdf-rust on a NAS
# would take hours, rustup pulls a prebuilt toolchain in ~2 min.

ASDF_BIN="$HOME/.local/bin/asdf"
if [[ ! -x "$ASDF_BIN" ]]; then
    asdf_ver=$(curl -fsSL https://api.github.com/repos/asdf-vm/asdf/releases/latest \
               | grep -o '"tag_name": "[^"]*"' | head -1 | sed 's/.*: "\(.*\)".*/\1/')
    log "installing asdf $asdf_ver -> $ASDF_BIN"
    tmpd=$(mktemp -d)
    curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/${asdf_ver}/asdf-${asdf_ver}-linux-amd64.tar.gz" \
        | tar -xz -C "$tmpd"
    install -m 0755 "$tmpd/asdf" "$ASDF_BIN"
    rm -rf "$tmpd"
fi

# asdf-deno plugin + install (pins tracked in ~/.tool-versions).
"$ASDF_BIN" plugin list 2>/dev/null | grep -q '^deno$' || \
    "$ASDF_BIN" plugin add deno https://github.com/asdf-community/asdf-deno.git

DENO_VER=2.7.7
if [[ ! -x "$HOME/.asdf/installs/deno/$DENO_VER/bin/deno" ]]; then
    if command -v unzip &>/dev/null; then
        log "installing deno $DENO_VER via asdf"
        "$ASDF_BIN" install deno "$DENO_VER"
    else
        # unzip missing (opkg install failed or user opted out). Grab the same
        # release asset asdf-deno would fetch and extract with python's zipfile.
        warn "unzip missing — installing deno $DENO_VER manually (python fallback)"
        tmpd=$(mktemp -d)
        curl -fsSL "https://github.com/denoland/deno/releases/download/v${DENO_VER}/deno-x86_64-unknown-linux-gnu.zip" \
            -o "$tmpd/deno.zip"
        python3 -c "import zipfile,sys; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])" \
            "$tmpd/deno.zip" "$tmpd"
        install -Dm 0755 "$tmpd/deno" "$HOME/.asdf/installs/deno/$DENO_VER/bin/deno"
        rm -rf "$tmpd"
        "$ASDF_BIN" reshim deno "$DENO_VER" 2>/dev/null || true
    fi
fi
"$ASDF_BIN" set -u deno "$DENO_VER"

# rustup + nightly. Synology mounts /tmp noexec; point rustup at an in-home
# scratch dir so it can execute rustup-init.
if [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
    log "installing rustup + rust nightly (~2 min)"
    mkdir -p "$HOME/.tmp"
    TMPDIR="$HOME/.tmp" curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs \
        | TMPDIR="$HOME/.tmp" sh -s -- \
              --profile minimal --default-toolchain nightly -y --no-modify-path
fi

# --- 5. symlinks -------------------------------------------------------------
# Explicit symlinks (no `stow`) so it's transparent what points where and easy
# to unwind. Only NAS-relevant configs: shell, git, tmux, nvim.

link() {
    local src=$1 dst=$2
    mkdir -p "$(dirname "$dst")"
    # If already the correct symlink, leave it.
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        return
    fi
    # Zero-byte auto-created files (e.g. zsh-abbr writing an empty
    # user-abbreviations on first launch) are safe to drop rather than back up.
    if [[ -f "$dst" && ! -L "$dst" && ! -s "$dst" ]]; then
        rm -f "$dst"
    fi
    # A real file/dir with content: back it up once so nothing is lost.
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        local bak="${dst}.pre-dotfiles.$(date +%Y%m%d%H%M%S)"
        warn "backing up existing $dst -> $bak"
        mv "$dst" "$bak"
    fi
    ln -sfn "$src" "$dst"
    log "linked $dst -> $src"
}

link "$DOTFILES_DIR/git/.gitconfig"                          "$HOME/.gitconfig"
link "$DOTFILES_DIR/git/.gitignore_global"                   "$HOME/.gitignore_global"
link "$DOTFILES_DIR/nas/git-config.local"                    "$HOME/.config/git/config.local"
link "$DOTFILES_DIR/config/.config/tmux/tmux.conf"           "$HOME/.config/tmux/tmux.conf"
link "$DOTFILES_DIR/config/.config/zsh-abbr/user-abbreviations" \
                                                             "$HOME/.config/zsh-abbr/user-abbreviations"
[[ -d "$DOTFILES_DIR/config/.config/nvim" ]] && \
    link "$DOTFILES_DIR/config/.config/nvim"                 "$HOME/.config/nvim"
[[ -d "$DOTFILES_DIR/config/.config/vim" ]] && \
    link "$DOTFILES_DIR/config/.config/vim"                  "$HOME/.config/vim"

# --- 6. .zshenv one-liner ----------------------------------------------------

if [[ ! -f "$HOME/.zshenv" ]] || ! grep -q '~/dotfiles/zsh/.zshenv' "$HOME/.zshenv"; then
    log "writing ~/.zshenv"
    cat >"$HOME/.zshenv" <<'EOF'
export ZDOTDIR=~/dotfiles/zsh
[[ -f "$ZDOTDIR/.zshenv" ]] && . "$ZDOTDIR/.zshenv"
EOF
fi

# --- 7. auto-exec zsh from login shell --------------------------------------
# DSM's `chsh` is unreliable (synouser overrides /etc/passwd on next login),
# so instead hook the existing `.profile` to hand off to zsh interactively.

PROFILE="$HOME/.profile"
touch "$PROFILE"
if ! grep -qF "$PROFILE_MARKER" "$PROFILE"; then
    log "appending zsh auto-exec block to $PROFILE"
    cat >>"$PROFILE" <<EOF

$PROFILE_MARKER
# Hand off interactive logins to zsh from Entware. Guards:
#   -o interactive: skip non-interactive shells (scp, rsync, cron)
#   -z \$ZSH_VERSION: don't recurse if already in zsh
#   -x /opt/bin/zsh: only if zsh actually installed
if [ -x /opt/bin/zsh ] && [ -z "\$ZSH_VERSION" ] && case \$- in *i*) true;; *) false;; esac; then
    export SHELL=/opt/bin/zsh
    exec /opt/bin/zsh -l
fi
# <<< dotfiles/install-nas.sh: auto-exec zsh <<<
EOF
fi

# Best-effort chsh (harmless if DSM ignores it).
if ! grep -qx /opt/bin/zsh /etc/shells 2>/dev/null; then
    echo /opt/bin/zsh | sudo tee -a /etc/shells >/dev/null
fi
sudo chsh -s /opt/bin/zsh "$USER" 2>/dev/null || \
    warn "chsh failed — that's expected on DSM; the .profile hook will start zsh instead."

# --- done --------------------------------------------------------------------

log "done."
cat <<'EOF'

Next steps:
  1. Open a new SSH session (or run: exec /opt/bin/zsh -l).
  2. First zsh start will run `antidote bundle` to build the static plugin
     file — takes ~15–30 s while it clones the plugin repos. Subsequent
     starts use the cached bundle and should be near-instant.
  3. If p10k glyphs render as tofu, install a Nerd Font in your SSH client
     (Ghostty, iTerm, Alacritty, etc.). The NAS itself doesn't render fonts.

EOF
