# Azure functions

akslogin() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: akslogin <resource-group> <cluster-name>"
    return 1
  fi
  az aks get-credentials --resource-group "$1" --name "$2"
}

kvs() {
  if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo "Usage: kvs <env> <secret-name> <file>"
    return 1
  fi
  [[ -f "$3" ]] || { echo "File not found: $3"; return 1; }
  az keyvault secret set --vault-name "sensey-${1}-kv" --name "$2" --file "$3"
}

kvc() {
  if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo "Usage: kvc <env> <cert-name> <file>"
    return 1
  fi
  [[ -f "$3" ]] || { echo "File not found: $3"; return 1; }
  az keyvault certificate import --vault-name "sensey-${1}-kv" --name "$2" --file "$3"
}
