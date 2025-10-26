# Docker aliases
alias d='docker'
alias dps='docker ps'
alias di='docker images'

de() {
  docker exec -it $1 /bin/bash
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
  docker inspect "$1" | grep IPAddress
}

# If you know the network name
dni() {
  docker network inspect "$1"
}

dbr() {
  app_name="$1"
  local_port="${2:-8080}"
  exposed_port="${3:-8080}"

  if [ -z "$app_name" ]; then
    echo "Error: app_name is required."
    echo "Usage: dbr <app_name> [local_port] [exposed_port]"
    return 1
  fi

  # Stop and remove any existing container with the same name
  if docker ps -a --format '{{.Names}}' | grep -w "$app_name" >/dev/null 2>&1; then
    echo "Stopping and removing existing container: $app_name"
    docker stop "$app_name" >/dev/null 2>&1
    docker rm "$app_name" >/dev/null 2>&1
  fi

  echo "Building image $app_name:latest..."
  docker buildx build --load -t "${app_name}:latest" .

  echo "Running container $app_name on ${local_port}:${exposed_port}..."
  docker run -d --name "$app_name" -p "${local_port}:${exposed_port}" "${app_name}:latest"
}
