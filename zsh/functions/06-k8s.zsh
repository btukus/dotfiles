# Kubernetes functions

# Kubernetes busybox
busy() {
  local manifest="${HOME}/drive/mac/development/k8s_resources/busybox.yaml"
  test -f "$manifest" || { echo "$manifest not found"; return 1; }
  kubectl apply -f "$manifest"
}

# Helm show values
hsv() {
  [[ -n "$1" ]] || { echo "Usage: hsv <chart> [output-file]"; return 1; }
  if [ -n "$2" ]; then
    helm show values "$1" > "$2"
  else
    helm show values "$1"
  fi
}

# k9s with context switching
ks() {
  if [ "$1" = "d" ]; then
    kubectl config use-context sensey-dev-aks || { echo "Context not found: sensey-dev-aks"; return 1; }
    k9s
  elif [ "$1" = "p" ]; then
    kubectl config use-context sensey-prod-aks || { echo "Context not found: sensey-prod-aks"; return 1; }
    k9s
  else
    k9s
  fi
}
