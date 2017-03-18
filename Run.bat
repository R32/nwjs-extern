@echo off

@echo run nw.exe
set NODE_WEBKIT="E:\Program Files\nw-sdk\nw.exe"
set APP_CASTLE="bin"
rem http://stackoverflow.com/questions/162291/how-to-check-if-a-process-is-running-via-a-batch-script
tasklist /FI "IMAGENAME eq nw.exe" /NH | find /I /N "nw.exe">NUL
if "%ERRORLEVEL%"=="1" start "" %NODE_WEBKIT% %APP_CASTLE%
