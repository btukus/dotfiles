# General Terraform aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfv='terraform validate'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfo='terraform output'
alias tff='terraform fmt'
alias tfw='terraform workspace'
alias tfr='terraform refresh'

# Terraform workspace-specific aliases
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'
alias tfwn='terraform workspace new'
alias tfwd='terraform workspace delete'

# Terraform apply and destroy with auto-approval (use with caution!)
alias tfap='terraform apply -auto-approve'
alias tfdp='terraform destroy -auto-approve'

# Terraform state management aliases
alias tfs='terraform state'
alias tfss='terraform state show'
alias tfsl='terraform state list'
alias tfsrm='terraform state rm'
alias tfsmv='terraform state mv'
alias tfsp='terraform state push'
alias tfspull='terraform state pull'

# Terraform plan output file
alias tfpout='terraform plan -out=tfplan'
alias tfpaout='terraform apply "tfplan"'

