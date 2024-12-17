DEST_PATH=~/[[PROJECT_NAME]]/
DEST_HOST=example@host
CONTAINER_NAME=[[PROJECT_NAME]]-[[PROJECT_NAME]]-1

ENTRYPOINT=cmd/main.go

SOURCE_PATH:=$(subst /makefile,,$(realpath $(lastword $(MAKEFILE_LIST))))
SSH_PATH:=$(if ${SystemRoot},${SystemRoot}\SysNative\OpenSSH\ssh.exe,ssh)
SSH_CMD=${SSH_PATH} ${DEST_HOST}

all: deploy

deploy: up sleep ps logs

run:
	go run ${ENTRYPOINT}

copy:
	tar --exclude=.git/* -C "${SOURCE_PATH}" -cz . | (${SSH_CMD} "mkdir -p ${DEST_PATH} && cd ${DEST_PATH} && tar -xzv --overwrite -f -")

up: copy
	${SSH_CMD} "cd ${DEST_PATH}; docker compose up -d --build"

ps:
	${SSH_CMD} "docker ps -f name=${CONTAINER_NAME}"

logs:
	${SSH_CMD} "docker logs ${CONTAINER_NAME}"

sleep:
	timeout /T 5 /NOBREAK > NUL