#!/bin/bash

alias azlogin='az login'
alias azlogout='az logout'
alias azlist='az account list'
alias azset='az account set'
alias azshow='az account show'
alias azsubs='az account subscription list'
alias azsubset='az account set --subscription '
alias subd='az account set --subscription Development'
alias subp='az account set --subscription Sensey'
alias azgroup='az group list'
alias azgroupcreate='az group create --name '
alias azgroupdelete='az group delete --name '
alias azgroupshow='az group show --name '
alias azgroupupdate='az group update --name '
alias azgrouplock='az group lock'
alias azgroupunlock='az group unlock'

akslogin() { az aks get-credentials --resource-group $1 --name $2 }

kvs() {
  az keyvault secret set --vault-name "sensey-${1}-kv" --name "$2" --file "$3"
}

kvc() {
  az keyvault certificate import --vault-name "sensey-${1}-kv" --name "$2" --file "$3" 
}
