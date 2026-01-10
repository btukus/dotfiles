# Load SSH keys silently
ssh_keys=(github gitlab bitbucket devops)
for n in ${ssh_keys[@]}; do
  if [[ -f ~/.ssh/$n/$n ]]; then
    ssh-add ~/.ssh/$n/$n &>/dev/null
  fi
done
