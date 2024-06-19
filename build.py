import os
import shutil
import subprocess
import sys
import threading
import time
from datetime import datetime

import telegram

VERSION_NAME = '|'


def thread_build():
    if sys.platform == 'win32':
        some_command = 'cmd /k "flutter build apk --release"'
        p = subprocess.Popen(some_command)
        p.wait()
    else:
        os.system('flutter --no-color build apk')


def thread_send():
    if sys.platform == 'win32':
        path = 'build\\app\\outputs\\flutter-apk\\app-release.apk'
        target = 'build\\app\\outputs\\flutter-apk\\Meloha_' + VERSION_NAME + '_' + datetime.now().strftime(
            "%Y%m%d") + '_release.apk'
    else:
        path = 'build/app/outputs/flutter-apk/app-release.apk'
        target = 'build/app/outputs/flutter-apk/Meloha_' + VERSION_NAME + '_' + datetime.now().strftime(
            "%Y%m%d") + '_release.apk'

    timeCreated = 0
    while True:
        time.sleep(1)
        if timeCreated == 0:
            try:
                timeCreated = os.path.getmtime(path)
            except:
                timeCreated = 1
            print('start ' + str(timeCreated))
        if os.path.isfile(path) and timeCreated != os.path.getmtime(path):
            shutil.copy(path, target)
            document = open(target, 'rb')
            telegram_notify = telegram.Bot("5930912011:AAGn3KLjHxqfnKEjFSfXTeXhHyWJKf9eZR8")
            isDone = False
            retryCount = 0
            while not isDone and retryCount < 5:
                try:
                    telegram_notify.send_document(-1001717163820, document) # Hearlink work group
                    isDone = True
                except:
                    print('ERROR PUSHING APK TO TELEGRAM ' + str(retryCount) + ' RETRY')
                    isDone = False
                    time.sleep(5)
                    retryCount += 1

            # telegram_notify.send_document(-1001728568573, document) # Hearlink ghep API
            # telegram_notify.send_document(-885205231, document) # Test group
            print('done ' + str(os.path.getmtime(path)))

            if not isDone:
                # open path in finder/explorer
                if sys.platform == 'win32':
                    os.system('explorer ' + path.replace('\\app-release.apk', ''))
                else:
                    os.system('open ' + path.replace('/app-release.apk', ''))

            sys.exit(0)
            raise SystemExit(0)


if __name__ == "__main__":
    path = 'build/app/outputs/flutter-apk'
    if sys.platform == 'win32':
        path = 'build\\app\\outputs\\flutter-apk\\'
    try:
        for file in os.listdir(path):
            if file.endswith(".apk"):
                os.remove(os.path.join(path, file))
                print('DELETE ' + os.path.join(path, file))
    except:
        print('FOUND NO APK FILE TO DELETE')

    filepath = 'pubspec.yaml'
    with open(filepath) as fp:
        line = fp.readline()
        # cnt = 1
        while line:
            # print("Line {}: {}".format(cnt, line.strip()))
            line = fp.readline()
            # cnt += 1
            if line.strip().startswith('version: '):
                VERSION_NAME = line.strip().replace('version: ', '')
                break

    t = threading.Thread(target=thread_build, args=[])
    t.start()
    t = threading.Thread(target=thread_send, args=[])
    t.start()
