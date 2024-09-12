alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kl='kubectl logs'

# Kubectl config
alias kcc='kubectl config current-context'
alias kcg='kubectl config get-contexts'
alias kcs='kubectl config set-context'
alias kcu='kubectl config use-context'
alias kns='kubens'
alias kcl='kubectx'

# kustomize
alias kfix='kustomize edit fix --vars'
alias kbuild='kustomize build'

# k9s
ks() {
  if [ "$1" = "d" ]; then
    kubectl config use-context sensey-dev-aks && k9s
  elif [ "$1" = "p" ]; then
    kubectl config use-context sensey-prod-aks && k9s
  else
    k9s;
  fi
}

ksns () {
  if [ "$1" = "t" ]; then
    kubectl config use-context AKS20AKSINFOPLUS300-T && k9s
  elif [ "$1" = "a" ]; then
    kubectl config use-context AKS20AKSINFOPLUS200-A && k9s
  elif [ "$1" = "p" ]; then
    kubectl config use-context AKS20AKSINFOPLUS200-P && k9s
  elif [ "$1" = "ht" ]; then
    kubectl config use-context AKS20REISINFO100-T && k9s
  elif [ "$1" = "ha" ]; then
    kubectl config use-context AKS20REISINFO100-A && k9s
  elif [ "$1" = "hp" ]; then
    kubectl config use-context AKS20REISINFO100-P && k9s
  else
    k9s;
  fi
}

# k8s resources
alias busy='kubectl apply -f ${HOME}/drive/mac/development/k8s_resources/busybox.yaml'
