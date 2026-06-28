export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Java home setup
[[ -f ~/.asdf/plugins/java/set-java-home.zsh ]] && . ~/.asdf/plugins/java/set-java-home.zsh

# Rust environment (resolve version without spawning asdf)
# Prefer the global ~/.tool-versions pin; fall back to the newest installed.
RUST_VERSION=""
if [[ -f "$HOME/.tool-versions" ]]; then
  RUST_VERSION=$(awk '$1 == "rust" {print $2; exit}' "$HOME/.tool-versions")
fi
if [[ -z "$RUST_VERSION" ]]; then
  for _rust_dir in "$HOME"/.asdf/installs/rust/*(/N); do
    RUST_VERSION="${_rust_dir:t}"
  done
  unset _rust_dir
fi
[[ -n "$RUST_VERSION" && -f "$HOME/.asdf/installs/rust/$RUST_VERSION/env" ]] && \
  . "$HOME/.asdf/installs/rust/$RUST_VERSION/env"
