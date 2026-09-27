export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# JAVA_HOME / JDK_HOME for the java version asdf selects here. Same result as the plugin's
# set-java-home.zsh, but it only asks asdf again when the directory or a .tool-versions
# file on the way up changed, instead of forking `asdf which java` before every prompt.
if [[ -d ~/.asdf/plugins/java ]]; then
  zmodload -F zsh/stat b:zstat
  _asdf_java_home() {
    local d=$PWD key=$PWD java
    while :; do
      [[ -f $d/.tool-versions ]] && key+=":$d$(zstat +mtime $d/.tool-versions 2>/dev/null)"
      [[ $d == / ]] && break
      d=${d:h}
    done
    [[ $key == $_asdf_java_key ]] && return
    typeset -g _asdf_java_key=$key
    java=$(asdf which java 2>/dev/null) || return 0
    [[ -n $java ]] && export JAVA_HOME=${java:A:h:h} JDK_HOME=${java:A:h:h}
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _asdf_java_home
fi

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

# rustup fallback (used on the NAS where compiling Rust via asdf would take
# hours; rustup ships prebuilt nightly binaries in minutes). Sourced only when
# asdf didn't already put a rust env on PATH.
[[ ! " $PATH " =~ ".cargo/bin" && -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
