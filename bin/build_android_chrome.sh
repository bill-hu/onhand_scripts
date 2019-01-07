. build/android/envsetup.sh
build_log=build_$(date "+%y%m%d%H%M").log
date >> $build_log 2>&1
nohup ninja -C out/Default chrome_public_apk  system_webview_apk>> $build_log 2>&1 &
