# Load SSH keys into the agent once per login (for agent forwarding; ~/.ssh/config already
# maps an IdentityFile per host, so plain ssh/git don't need this). Runs in the background
# and only when the agent is empty, so new shells don't pay for it.
() {
  local n
  local -a keys
  # One key per ~/.ssh/<name>/<name> (the layout the zsh Ansible role creates)
  for n in ~/.ssh/*(N/:t); do
    [[ -f ~/.ssh/$n/$n ]] && keys+=(~/.ssh/$n/$n)
  done
  (( $#keys )) || return
  { ssh-add -l >/dev/null 2>&1 || ssh-add -q $keys >/dev/null 2>&1 } &!
}
