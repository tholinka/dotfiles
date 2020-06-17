# docker config

# default docker-compose down args
alias docker-compose-down-remove="docker-compose down -v --remove-orphans --rmi local"

# default docker-compose up args
alias docker-compose-up="docker-compose up -d"
alias docker-compose-up-build="docker-compose-up --build"
alias docker-compose-up-build-single="docker-compose-up-build --no-deps"

# get new versions of images
alias docker-update-images="docker images --format \"{{.Repository}}:{{.Tag}}\" | grep -v \"<none>\" | xargs -L1 -P $(nproc --all) docker pull"

# assume we want to always prune volumes
alias docker-system-prune="docker system prune --volumes"

# default args to exec something
function docker-exec {
	docker exec -it $@
}
compdef __docker_complete_containers docker-exec

# default args to follow logs
function docker-logs {
	docker logs $@ --follow
}
compdef __docker_complete_containers docker-logs

# use buildkit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
