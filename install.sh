#!/bin/bash
#
# macOS development environment bootstrap.
# Safe to run either way:
#   curl -fsSL https://raw.githubusercontent.com/btukus/dotfiles/main/install.sh | bash
#   cd ~/dotfiles && ./install.sh
#
# Design notes:
# - Everything lives inside main(), called on the last line. Under `curl | bash`
#   this forces bash to parse the whole script before executing anything, so a
#   child process reading stdin can never swallow unexecuted script text.
# - Children that could read stdin get `</dev/null` explicitly anyway.
# - sudo prompts on /dev/tty (not stdin), so we cache credentials up front in
#   BOTH modes; the Homebrew installer then works with NONINTERACTIVE=1.

set -euo pipefail

DOTFILES_REPO="https://github.com/btukus/dotfiles.git"

load_brew_env() {
    # Works for both Apple Silicon and Intel.
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# CLT are "ready" only if the tools are actually usable, not merely if a
# developer dir is configured. A stale/interrupted install leaves
# `xcode-select -p` returning 0 while `xcrun clang` (used by git/brew) is missing.
clt_ready() {
    xcode-select -p &>/dev/null && xcrun --find clang &>/dev/null
}

main() {
    echo "=== macOS Development Environment Setup ==="

    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo "Error: this script is for macOS only." >&2
        exit 1
    fi

    # Keep the machine awake for the duration of this script (long downloads).
    if command -v caffeinate &>/dev/null; then
        caffeinate -dimu -w $$ &
    fi

    # --- sudo: prompt once, keep alive (both modes) -------------------------
    # sudo reads the password from /dev/tty, so this works even when stdin is
    # the curl pipe. Only skip if credentials are already cached.
    if ! sudo -n true 2>/dev/null; then
        if ! sudo -v </dev/tty; then
            echo "Error: could not obtain sudo credentials (no interactive terminal?)." >&2
            echo "Run 'sudo -v' first, then re-run this script." >&2
            exit 1
        fi
    fi
    # Confirm the credential is actually cached and reusable. Hardened sudoers
    # with `timestamp_timeout=0` accept `sudo -v` but cache nothing, which would
    # later break the keep-alive and Homebrew's non-interactive `sudo -n`.
    if ! sudo -n true 2>/dev/null; then
        echo "Error: sudo credentials could not be cached (sudoers likely sets" >&2
        echo "timestamp_timeout=0). Homebrew's non-interactive install needs reusable" >&2
        echo "cached sudo. Adjust the sudo policy or install Homebrew manually first." >&2
        exit 1
    fi
    # Keep-alive: set +e inside the subshell, because background jobs inherit
    # errexit and a single transient 'sudo -n' failure would silently kill the
    # loop (leading to surprise password prompts buried in brew output later).
    ( set +e; while kill -0 "$$" 2>/dev/null; do sudo -n true 2>/dev/null; sleep 50; done ) &
    SUDO_KEEPALIVE_PID=$!
    trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

    # --- 1. Xcode Command Line Tools (required for git, brew) ---------------
    # Install CLT ourselves and wait until they are genuinely usable BEFORE
    # touching Homebrew, so Homebrew never has to install them via its fragile
    # "press any key when done" gate (the cause of the abort on a fresh Mac).
    if ! clt_ready; then
        echo "Installing Xcode Command Line Tools..."
        # A stale/partial CLT directory is the trap: `xcode-select -p` succeeds
        # so nothing reinstalls, yet `xcode-select --switch` later fails with
        # "invalid developer directory". Worse, if the dir exists, a plain
        # `xcode-select --install` refuses ("already installed") and pops no
        # dialog. Remove the broken dir so the installer does a clean download.
        if [[ -d /Library/Developer/CommandLineTools ]]; then
            echo "Removing stale/broken Command Line Tools directory..."
            sudo rm -rf /Library/Developer/CommandLineTools
        fi
        xcode-select --install 2>/dev/null || true  # non-zero if already requested
        echo "A GUI installer for the Command Line Tools should appear — complete it."
        echo "Waiting for the tools to finish installing (this can take several minutes)..."
        local waited=0
        until clt_ready; do
            sleep 5
            waited=$((waited + 5))
            if (( waited % 60 == 0 )); then
                echo "  ...still waiting (${waited}s). Finish the GUI installer; if you closed it, run 'xcode-select --install' in another terminal."
            fi
            if (( waited >= 1800 )); then
                echo "Error: timed out (30 min) waiting for Xcode Command Line Tools." >&2
                echo "Install them manually with 'xcode-select --install', then re-run this script." >&2
                exit 1
            fi
        done
        echo "Xcode Command Line Tools installed."
    fi

    # --- 2. Homebrew ---------------------------------------------------------
    # Load shellenv FIRST: brew may be installed but not on PATH in this shell.
    load_brew_env
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        # NONINTERACTIVE=1 skips the "Press RETURN to continue" prompt (the
        # classic hang in interactive mode); sudo is already cached so the
        # installer's `sudo -n` calls succeed. </dev/null keeps the installer
        # and its children away from our stdin.
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
            </dev/null
        load_brew_env
    fi
    if ! command -v brew &>/dev/null; then
        echo "Error: Homebrew installation failed (brew not found after install)." >&2
        exit 1
    fi

    # --- 3. Dotfiles repo ------------------------------------------------------
    local dotfiles_dir="$HOME/dotfiles"
    # If executed from a file inside a checkout (local mode), use that checkout
    # instead of cloning a second copy. BASH_SOURCE is empty under curl | bash.
    if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]:-}" ]]; then
        local script_dir
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [[ -f "$script_dir/brew/Brewfile.macos" ]]; then
            dotfiles_dir="$script_dir"
        fi
    fi
    # Accept any valid checkout (a linked worktree/submodule has `.git` as a
    # file, not a dir), clone when absent, and reject a non-repo directory.
    if ! git -C "$dotfiles_dir" rev-parse --git-dir &>/dev/null; then
        if [[ -e "$dotfiles_dir" ]]; then
            echo "Error: $dotfiles_dir exists but is not a git repository (interrupted clone?)." >&2
            echo "Move it aside and re-run this script." >&2
            exit 1
        fi
        echo "Cloning dotfiles..."
        git clone "$DOTFILES_REPO" "$dotfiles_dir" </dev/null
    fi
    cd "$dotfiles_dir"

    # --- 4. Brew packages (includes ansible, stow, etc.) -----------------------
    # Retry: a fresh Brewfile pulls ~15 GB across many large casks, so a single
    # transient fetch failure (ghcr.io rate-limit, network blip) makes the whole
    # `brew bundle` exit non-zero. It is idempotent and caches successful
    # downloads, so re-running quickly clears transient errors.
    local had_failures=0
    local brew_tries=0
    echo "Installing brew packages..."
    until brew bundle --file="$dotfiles_dir/brew/Brewfile.macos" </dev/null; do
        brew_tries=$((brew_tries + 1))
        if (( brew_tries >= 3 )); then
            echo "Warning: brew bundle still failing after 3 attempts (continuing...)" >&2
            had_failures=1
            break
        fi
        echo "brew bundle failed (attempt ${brew_tries}/3) — retrying in 15s (transient fetch errors are common on a fresh install)..." >&2
        sleep 15
    done

    # --- 5. Ansible playbook (includes macOS settings) -------------------------
    hash -r  # forget stale command lookups; ansible was just installed
    if ! command -v ansible-playbook &>/dev/null; then
        echo "Error: ansible-playbook not found; 'brew bundle' likely failed above." >&2
        echo "Fix the brew errors and re-run this script (it is idempotent)." >&2
        exit 1
    fi
    echo "Running Ansible playbook..."
    if ! ansible-playbook "$dotfiles_dir/ansible/macos_playbook.yml" </dev/null; then
        echo "Warning: Ansible playbook had errors (continuing...)" >&2
        had_failures=1
    fi

    echo ""
    if (( had_failures )); then
        echo "=== Setup finished WITH WARNINGS ==="
        echo "Some steps failed above. This script is idempotent — resolve the errors"
        echo "and re-run it to complete the setup."
    else
        echo "=== Setup complete! ==="
    fi
    echo "Restart your terminal to apply all changes."
}

main "$@"
