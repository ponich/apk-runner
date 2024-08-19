#!/bin/bash

CONTAINER_NAME="ubuntu-24-04-container"

is_container_running() {
    docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

stop_and_remove_container() {
    echo "Останавливаем и удаляем контейнер..."
    docker-compose down --volumes --remove-orphans
}

start_container_and_enter_bash() {
    echo "Запускаем контейнер и входим в bash..."
    docker-compose up -d --build
    docker exec -it ${CONTAINER_NAME} /bin/bash
}

enter_container_bash() {
    echo "Входим в bash контейнера..."
    docker exec -it ${CONTAINER_NAME} /bin/bash
}

if is_container_running; then
    echo "Контейнер уже запущен. Входим в bash..."
    enter_container_bash
else
    stop_and_remove_container
    start_container_and_enter_bash
fi

stop_and_remove_container

