# Azure functions

akslogin() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: akslogin <resource-group> <cluster-name>"
    return 1
  fi
  az aks get-credentials --resource-group "$1" --name "$2"
}

# Key Vault helpers (kvs, kvc) live in the private overlay (dotfiles-private/zsh)
