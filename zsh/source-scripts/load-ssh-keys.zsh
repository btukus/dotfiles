# Source SSH keys
ssh_keys=(github gitlab bitbucket devops)
for n in ${ssh[@]}; do
  if [[ -f ~/.ssh/$n/$n ]]; then
    ssh-add ~/.ssh/$n/$n
  fi
done
