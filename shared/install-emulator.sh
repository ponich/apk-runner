#!/bin/bash

set -e

# Устанавливаем переменные окружения
export ANDROID_HOME=/root/android-sdk
export ANDROID_SDK_ROOT=/root/android-sdk
export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# Функция для вывода отладочной информации
debug_info() {
    echo "DEBUG: $1"
    ls -la $2
}

# Скачиваем Android command line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip commandlinetools-linux-10406996_latest.zip
rm commandlinetools-linux-10406996_latest.zip

# Создаем нужную структуру директорий
mkdir -p ${ANDROID_HOME}/cmdline-tools/latest
mv cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/
rmdir cmdline-tools

debug_info "Content of ANDROID_HOME" ${ANDROID_HOME}

# Принимаем лицензии и устанавливаем необходимые компоненты SDK
yes | sdkmanager --licenses
sdkmanager --verbose "platform-tools" "platforms;android-33" "system-images;android-33;google_apis;x86_64" "emulator"

debug_info "Content of system-images" ${ANDROID_HOME}/system-images

# Создаем AVD, автоматически принимая настройки по умолчанию и перезаписывая существующий, если он есть
echo "no" | avdmanager --verbose create avd -n test_avd -k "system-images;android-33;google_apis;x86_64" --force

debug_info "Content of .android/avd" /root/.android/avd

# Настраиваем конфигурацию AVD
mkdir -p /root/.android/avd/test_avd.avd
cat << EOF > /root/.android/avd/test_avd.avd/config.ini
avd.ini.encoding=UTF-8
path=$ANDROID_SDK_ROOT/system-images/android-33/google_apis/x86_64/
target=android-33
hw.device.name=pixel
hw.device.manufacturer=Google
hw.cpu.ncore=2
hw.ramSize=2048
hw.screen=touch
hw.mainKeys=no
hw.keyboard=yes
hw.gpu.enabled=yes
skin.name=720x1280
hw.gpu.mode=auto
hw.initialOrientation=Portrait
hw.camera.back=emulated
hw.camera.front=emulated
disk.dataPartition.size=2048M
EOF

# Создаем файл ini для AVD
cat << EOF > /root/.android/avd/test_avd.ini
avd.ini.encoding=UTF-8
path=/root/.android/avd/test_avd.avd
target=android-33
EOF

# Проверяем, что AVD создан
avdmanager list avd

# Выводим значения переменных окружения для проверки
echo "ANDROID_HOME: $ANDROID_HOME"
echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "PATH: $PATH"