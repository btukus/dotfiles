# Kubernetes functions

# Kubernetes busybox
busy() {
  local manifest="${HOME}/code/k8s_resources/busybox.yaml"
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

# `ks` (k9s with context switching) lives in the private overlay (dotfiles-private/zsh)
