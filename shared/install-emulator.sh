#!/bin/bash

set -e

export ANDROID_HOME=/root/android-sdk
export ANDROID_SDK_ROOT=/root/android-sdk
export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

debug_info() {
    echo "DEBUG: $1"
    ls -la $2
}

wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip commandlinetools-linux-10406996_latest.zip
rm commandlinetools-linux-10406996_latest.zip

mkdir -p ${ANDROID_HOME}/cmdline-tools/latest
mv cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/
rmdir cmdline-tools

debug_info "Content of ANDROID_HOME" ${ANDROID_HOME}

yes | sdkmanager --licenses

# Устанавливаем компоненты по отдельности и проверяем результат
sdkmanager --verbose "platform-tools"
sdkmanager --verbose "platforms;android-33"
sdkmanager --verbose "system-images;android-33;google_apis;x86_64"
sdkmanager --verbose "emulator"

debug_info "Content of system-images" ${ANDROID_HOME}/system-images

# Проверяем, что системный образ установлен
if [ ! -d "${ANDROID_HOME}/system-images/android-33/google_apis/x86_64" ]; then
    echo "System image not found. Trying to reinstall..."
    sdkmanager --uninstall "system-images;android-33;google_apis;x86_64"
    sdkmanager --verbose "system-images;android-33;google_apis;x86_64"
fi

debug_info "Content of system-images after check" ${ANDROID_HOME}/system-images

echo "no" | avdmanager --verbose create avd -n test_avd -k "system-images;android-33;google_apis;x86_64" --force

debug_info "Content of .android/avd" /root/.android/avd

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

cat << EOF > /root/.android/avd/test_avd.ini
avd.ini.encoding=UTF-8
path=/root/.android/avd/test_avd.avd
target=android-33
EOF

avdmanager list avd

echo "ANDROID_HOME: $ANDROID_HOME"
echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "PATH: $PATH"