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

# Get IP address or hostname of container
dip() {
  docker inspect "$1" | grep IPAddress;
}

# If you know the network name
dni() {
  docker network inspect "$1";
}
