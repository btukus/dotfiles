# Docker aliases
alias d='docker'
alias dps='docker ps'
alias di='docker images'

de () {
  docker exec -it $1 /bin/bash;
}

# Docker compose
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcub='docker-compose up --build -d'
alias dcubl='docker-compose up --build'
alias dspa='docker system prune --all'

alias fd='nvim Dockerfile'

# Get IP address or hostname of container
dip() {
  docker inspect "$1" | grep IPAddress;
}

# If you know the network name
dni() {
  docker network inspect "$1";
}

alias kc='docker run -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  -v ./realm-export-2.json:/opt/keycloak/data/import/realm-export-2.json \
  quay.io/keycloak/keycloak:26.1.0 \
  start-dev --import-realm
'
