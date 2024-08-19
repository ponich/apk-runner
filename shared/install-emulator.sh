#!/bin/bash

set -e

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

# Создаем AVD, автоматически принимая настройки по умолчанию
echo "no" | avdmanager create avd -n test_avd -k "system-images;android-33;google_apis;x86_64"