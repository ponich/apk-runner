FROM ubuntu:24.04

ENV ANDROID_HOME /root/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator
ENV TZ=UTC

# Установка необходимых пакетов
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    cpu-checker \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    kmod \
    default-jdk \
    wget \
    unzip \
    libncurses6 \
    libsdl1.2debian && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Устанавливаем рабочую директорию
WORKDIR /root

# Скачиваем Android command line tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip && \
    unzip commandlinetools-linux-10406996_latest.zip && \
    rm commandlinetools-linux-10406996_latest.zip

# Создаем нужную структуру директорий
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    mv cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/ && \
    rmdir cmdline-tools

# Принимаем лицензии и устанавливаем необходимые компоненты SDK
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "system-images;android-33;google_apis;x86_64"

# Создаем AVD, автоматически принимая настройки по умолчанию
# RUN echo "no" | avdmanager create avd -n test_avd -k "system-images;android-33;google_apis;x86_64"

CMD ["/bin/bash"]