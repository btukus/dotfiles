alias hup='helm repo update && helm search repo'
alias hls='helm list'
alias hinst='helm install'
alias hupg='helm upgrade'
alias huninst='helm uninstall'
alias hget='helm get'
alias hdebug='helm install --debug --dry-run'
alias htmpl='helm template'
alias hlint='helm lint'
alias hnew='helm create'
alias hhist='helm history'


hsv() {
  if [ -n "$2" ]; then
    helm show values "$1" > "$2"
  else
    helm show values "$1"
  fi
}
