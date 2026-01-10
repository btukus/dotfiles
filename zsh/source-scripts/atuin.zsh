# Atuin shell history
# Must use zvm_after_init due to zsh-vi-mode conflict
# See: https://github.com/atuinsh/atuin/issues/977
if command -v atuin &> /dev/null; then
  function _atuin_init() {
    eval "$(atuin init zsh --disable-up-arrow)"
  }
  zvm_after_init_commands+=(_atuin_init)
fi
