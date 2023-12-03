alias azlogin='az login'
alias azlogout='az logout'
alias azlist='az account list'
alias azset='az account set'
alias azshow='az account show'
alias azsubs='az account subscription list'
alias azsubset='az account set --subscription '
alias azgroup='az group list'
alias azgroupcreate='az group create --name '
alias azgroupdelete='az group delete --name '
alias azgroupshow='az group show --name '
alias azgroupupdate='az group update --name '
alias azgrouplock='az group lock'
alias azgroupunlock='az group unlock'

akslogin() { az aks get-credentials --resource-group $1 --name $2 }