cls 
@ECHO OFF 
SET NGINX_PATH=C: 
SET NGINX_DIR=C:\nginx\
SET PHP_DIR=C:\php\php-5.6.22\
SET MYSQL_DIR=C:\mysql-5.6.28-winx64
color 0a 
TITLE App Management
GOTO MENU 
:MENU 
CLS 
ECHO. 
ECHO. * * * * Nginx Management  * * * * * * *
ECHO. * * 
ECHO. * Nginx/PHP 1 Start 2 Close 3 Restart *
ECHO. * MYSQL 4 Start 5 Close 6 Restart     *
ECHO. *                                     *
ECHO. * Quit quit                           *
ECHO. *                                     *
ECHO. * * * * * * * * * * * * * * * * * * * *
ECHO.
:LIST
SET n_nginx=0
SET n_php=0
SET n_mysqld=0
tasklist /FI "IMAGENAME eq nginx.exe" | find "nginx.exe" > nul && SET n_nginx=1
tasklist /FI "IMAGENAME eq php-cgi.exe" | find "php-cgi.exe" > nul && SET n_php=1
tasklist /FI "IMAGENAME eq mysqld.exe" | find "mysqld.exe" > nul && SET n_mysqld=1
IF "%n_nginx%"=="1" (ECHO. Nginx............running) ELSE ECHO. Nginx............close
IF "%n_php%"=="1" (ECHO. PHP..............running) ELSE ECHO. PHP..............close
IF "%n_mysqld%"=="1" (ECHO. MYSQLD...........running) ELSE ECHO. MYSQLD...........close
ECHO.
ECHO.Please input the operation number:
set /p ID= 
IF "%id%"=="1" GOTO cmd1 
IF "%id%"=="2" GOTO cmd2 
IF "%id%"=="3" GOTO cmd3
IF "%id%"=="4" GOTO cmd4
IF "%id%"=="5" GOTO cmd5
IF "%id%"=="6" GOTO cmd6
IF "%id%"=="list" GOTO LIST
IF "%id%"=="quit" EXIT
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
ECHO.
ECHO.Start PHP CGI...
tasklist /FI "IMAGENAME eq php-cgi.exe" | find "php-cgi.exe" > nul && ECHO.php-cgi already run && PAUSE && GOTO MENU
IF NOT EXIST %PHP_DIR%php-cgi.exe ECHO %PHP_DIR%php-cgi.exe command is not exist
%NGINX_PATH% 
cd %PHP_DIR% 
IF EXIST %PHP_DIR% start /B %PHP_DIR%php-cgi.exe -b 9001
IF EXIST %PHP_DIR% start /B %PHP_DIR%php-cgi.exe -b 9000
tasklist /FI "IMAGENAME eq php-cgi.exe" | find "php-cgi.exe" > nul && ECHO Start OK
tasklist /FI "IMAGENAME eq php-cgi.exe" | find "No tasks" > nul && ECHO.php-cgi Start Faild. 
PAUSE 
GOTO MENU 
:cmd2 
ECHO. 
ECHO.Close Nginx...... 
taskkill /F /IM nginx.exe > nul 
ECHO.OK 
ECHO.Close php-cgi...
taskkill /F /IM php-cgi.exe > nul
ECHO.OK
PAUSE 
GOTO MENU 
:cmd3 
ECHO. 
ECHO.Close Nginx...... 
taskkill /F /IM nginx.exe > nul 
ECHO.OK 
ECHO.Close php-cgi...
taskkill /F /IM php-cgi.exe > nul
ECHO.OK
GOTO cmd1 
:cmd4
ECHO.
ECHO.Start Mysql...
tasklist /FI "IMAGENAME eq mysqld.exe" | find "mysqld.exe" > nul && ECHO.Mysql already run && PAUSE && GOTO MENU
IF NOT EXIST %MYSQL_DIR%/bin/mysqld.exe ECHO %MYSQL_DIR%mysqld.exe command is not exist
%MYSQL_PATH%
cd %MYSQL_DIR%
IF EXIST %MYSQL_DIR% start /b %MYSQL_DIR%/bin/mysqld.exe
tasklist /FI "IMAGENAME eq mysqld.exe" | find "mysqld.exe" > nul && ECHO Start OK
tasklist /FI "IMAGENAME eq mysqld.exe" | find "No tasks" > nul && ECHO.Mysql Start Faild. Please see the Mysql error Log
PAUSE
GOTO MENU
:cmd5
ECHO.
ECHO.Close Mysql......
taskkill /F /IM mysqld.exe > nul
ECHO.OK
PAUSE
GOTO MENU
:cmd6
ECHO.
ECHO.Close Mysql......
taskkill /F /IM mysqld.exe > nul
ECHO.OK
GOTO cmd1
GOTO MENU