cls 
@ECHO OFF 
SET NGINX_PATH=C: 
SET NGINX_DIR=C:\nginx\
color 0a 
TITLE Nginx Management
GOTO MENU 
:MENU 
CLS 
ECHO. 
ECHO. * * * * Nginx Management  * * * *
ECHO. * * 
ECHO. * 1 Start Nginx   * 
ECHO. * * 
ECHO. * 2 Close Nginx   * 
ECHO. * * 
ECHO. * 3 Restart Nginx * 
ECHO. * * 
ECHO. * 4 Quit * 
ECHO. * * 
ECHO. * * * * * * * * * * * * * * * * * 
ECHO. 
ECHO.Please input the operation number£º 
set /p ID= 
IF "%id%"=="1" GOTO cmd1 
IF "%id%"=="2" GOTO cmd2 
IF "%id%"=="3" GOTO cmd3 
IF "%id%"=="4" EXIT 
PAUSE 
:cmd1 
ECHO. 
ECHO.Start Nginx...... 
tasklist /FI "IMAGENAME eq nginx.exe" | find "nginx.exe" > nul && ECHO.Nginx already run && PAUSE && GOTO MENU
IF NOT EXIST %NGINX_DIR%nginx.exe ECHO %NGINX_DIR%nginx.exe command is not exist
%NGINX_PATH% 
cd %NGINX_DIR% 
IF EXIST %NGINX_DIR% start %NGINX_DIR%nginx.exe
ping -n 2 127.0.0.1>nul 
tasklist /FI "IMAGENAME eq nginx.exe" | find "nginx.exe" > nul && ECHO Start OK
tasklist /FI "IMAGENAME eq nginx.exe" | find "No tasks" > nul && ECHO.Nginx Start Faild. Please see the Nginx error Log
PAUSE 
GOTO MENU 
:cmd2 
ECHO. 
ECHO.Close Nginx...... 
taskkill /F /IM nginx.exe > nul 
ECHO.OK 
PAUSE 
GOTO MENU 
:cmd3 
ECHO. 
ECHO.Close Nginx...... 
taskkill /F /IM nginx.exe > nul 
ECHO.OK 
GOTO cmd1 
GOTO MENU