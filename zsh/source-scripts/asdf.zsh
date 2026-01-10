export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Java home setup
[[ -f ~/.asdf/plugins/java/set-java-home.zsh ]] && . ~/.asdf/plugins/java/set-java-home.zsh

# Rust environment (dynamically find current version)
RUST_VERSION=$(asdf current rust 2>/dev/null | awk '{print $2}')
[[ -n "$RUST_VERSION" && -f "$HOME/.asdf/installs/rust/$RUST_VERSION/env" ]] && \
  . "$HOME/.asdf/installs/rust/$RUST_VERSION/env"
