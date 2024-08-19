FROM ubuntu:24.04

ENV ANDROID_HOME /root/android-sdk
ENV ANDROID_SDK_ROOT /root/android-sdk
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

# Копируем и запускаем скрипт установки эмулятора
COPY ./shared/install-emulator.sh /root/install-emulator.sh
RUN chmod +x /root/install-emulator.sh && \
    /root/install-emulator.sh

CMD ["/bin/bash"]