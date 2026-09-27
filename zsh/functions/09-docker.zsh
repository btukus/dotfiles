# Docker functions

# Docker exec into container
de() {
  if [[ -z "$1" ]]; then
    echo "Usage: de <container>"
    return 1
  fi
  docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Get IP address of container
dip() {
  docker inspect "$1" 2>/dev/null | grep IPAddress || { echo "Not found"; return 1; }
}

# Docker network inspect
dni() {
  docker network inspect "$1" || { echo "Not found"; return 1; }
}

# Docker build and run
dbr() {
  local app_name="$1"
  local local_port="${2:-8080}"
  local exposed_port="${3:-8080}"
  if [ -z "$app_name" ]; then
    echo "Error: app_name is required."
    echo "Usage: dbr <app_name> [local_port] [exposed_port]"
    return 1
  fi
  if docker ps -a --format '{{.Names}}' | grep -w "$app_name" >/dev/null 2>&1; then
    echo "Stopping and removing existing container: $app_name"
    docker stop "$app_name" >/dev/null 2>&1
    docker rm "$app_name" >/dev/null 2>&1
  fi
  echo "Building image $app_name:latest..."
  docker buildx build --load -t "${app_name}:latest" . || { echo "Build failed"; return 1; }
  echo "Running container $app_name on ${local_port}:${exposed_port}..."
  docker run -d --name "$app_name" -p "${local_port}:${exposed_port}" "${app_name}:latest" || return 1
}
