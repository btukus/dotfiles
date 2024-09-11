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
alias ks='k9s'


# k8s resources
alias busy='kubectl apply -f ${HOME}/drive/mac/development/k8s_resources/busybox.yaml'
