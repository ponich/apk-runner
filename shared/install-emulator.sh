#!/bin/bash

set -e

# Устанавливаем переменные окружения
export ANDROID_HOME=/root/android-sdk
export ANDROID_SDK_ROOT=/root/android-sdk
export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# Скачиваем Android command line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip commandlinetools-linux-10406996_latest.zip
rm commandlinetools-linux-10406996_latest.zip

# Создаем нужную структуру директорий
mkdir -p ${ANDROID_HOME}/cmdline-tools/latest
mv cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/
rmdir cmdline-tools

# Принимаем лицензии и устанавливаем необходимые компоненты SDK
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-33" "system-images;android-33;google_apis;x86_64" "emulator"

# Создаем AVD, автоматически принимая настройки по умолчанию и перезаписывая существующий, если он есть
echo "no" | avdmanager create avd -n test_avd -k "system-images;android-33;google_apis;x86_64" --force

# Настраиваем конфигурацию AVD
mkdir -p ~/.android/avd/test_avd.avd
echo "avd.ini.encoding=UTF-8" > ~/.android/avd/test_avd.avd/config.ini
echo "path=$ANDROID_SDK_ROOT/system-images/android-33/google_apis/x86_64/" >> ~/.android/avd/test_avd.avd/config.ini

# Проверяем, что AVD создан
avdmanager list avd

# Выводим значения переменных окружения для проверки
echo "ANDROID_HOME: $ANDROID_HOME"
echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "PATH: $PATH"