# docker config

alias docker-compose-down="docker-compose down"
alias docker-compose-down-unmount="docker-compose down -v"
alias docker-compose-down-remove="docker-compose down -v --remove-orphans --rmi local"

alias docker-compose-up="docker-compose up -d"
alias docker-compose-up-build="docker-compose up --build -d"

function docker-exec-bash() {
	docker exec -it $@ bash
}
compdef __docker_complete_containers docker-exec-bash

function docker-logs {
	docker logs $@ --follow
}

compdef __docker_complete_containers docker-logs
