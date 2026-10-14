# Private overlay (~/dotfiles-private): work functions, abbreviations, hosts. Optional - a
# no-op when the checkout is missing. env.zsh is skipped here because .zshenv already sources it.
# Sourced at top level, not in a function, so a `typeset` in those files still declares a global.
for f in ~/dotfiles-private/zsh/*.zsh(N); do
  [[ ${f:t} == env.zsh ]] || source $f
done
unset f
