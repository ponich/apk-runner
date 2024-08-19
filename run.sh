#!/bin/bash

CONTAINER_NAME="ubuntu-24-04-container"

is_container_running() {
    docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

is_container_exists() {
    docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

start_container() {
    echo "Запускаем контейнер..."
    docker-compose up -d
}

stop_container() {
    echo "Останавливаем контейнер..."
    docker-compose stop
}

enter_container_bash() {
    echo "Входим в bash контейнера..."
    docker exec -it ${CONTAINER_NAME} /bin/bash
}

if is_container_running; then
    echo "Контейнер уже запущен. Входим в bash..."
    enter_container_bash
elif is_container_exists; then
    echo "Контейнер существует, но не запущен. Запускаем и входим в bash..."
    start_container
    enter_container_bash
else
    echo "Контейнер не существует. Создаем, запускаем и входим в bash..."
    docker-compose up -d --build
    enter_container_bash
fi

# Спрашиваем пользователя, хочет ли он остановить контейнер после выхода
read -p "Хотите ли вы остановить контейнер после выхода? (y/n) " choice
case "$choice" in
  y|Y ) stop_container;;
  n|N ) echo "Контейнер остается запущенным.";;
  * ) echo "Неверный ввод. Контейнер остается запущенным.";;
esac