# ~/.zshrc.d/docker.zsh — Docker aliases and helpers

if command -v docker >/dev/null 2>&1; then
  alias d='docker'
  alias di='docker images'
  alias dps='docker ps'
  alias dpsa='docker ps -a'

  # docker compose: prefer plugin form
  if docker compose version >/dev/null 2>&1; then
    alias dc='docker compose'
  elif command -v docker-compose >/dev/null 2>&1; then
    alias dc='docker-compose'
  fi

  # dex <container> [cmd]: exec into container (defaults to bash/sh)
  dex() {
    local container="${1:?Usage: dex <container> [cmd]}"
    local cmd="${2:-}"
    if [ -z "$cmd" ]; then
      docker exec -it "$container" bash 2>/dev/null || docker exec -it "$container" sh
    else
      docker exec -it "$container" "$cmd"
    fi
  }

  # dlogs <container> [lines]: tail logs
  dlogs() {
    docker logs -f --tail "${2:-100}" "${1:?Usage: dlogs <container> [lines]}"
  }

  # dclean: remove stopped containers, dangling images, unused volumes
  dclean() {
    docker container prune -f
    docker image prune -f
    docker volume prune -f
  }

  # dsh <container>: open shell
  dsh() {
    dex "${1:?Usage: dsh <container>}"
  }

  # dip <container>: show container IP
  dip() {
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
      "${1:?Usage: dip <container>}"
  }
fi
