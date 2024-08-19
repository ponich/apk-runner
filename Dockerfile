FROM budtmo/docker-android:latest

# Копируем APK в контейнер
COPY shared/app.apk /root/app.apk

# Устанавливаем APK
RUN adb install /root/app.apk

# Запускаем приложение и делаем скриншот
# CMD adb shell monkey -p $(aapt dump badging /root/app.apk | awk -F" " '/package/{gsub("name=|'"'"'","");  print $2}') 1 && \
#     sleep 10 && \
#     adb shell screencap -p /sdcard/screenshot.png && \
#     adb pull /sdcard/screenshot.png /root/screenshot.png