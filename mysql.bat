cls 
@ECHO OFF 
SET MYSQL_PATH=C: 
SET MYSQL_DIR=C:\mysql-5.6.28-winx64
color 0a 
TITLE MYSQLD
GOTO MENU 
:MENU 
CLS 
ECHO. 
ECHO. * * * * Mysql Management  * * * *
ECHO. * * 
ECHO. * 1 Start Mysql   * 
ECHO. * * 
ECHO. * 2 Close Mysql   * 
ECHO. * * 
ECHO. * 3 Restart Mysql   * 
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
ECHO.Start Mysql...
tasklist /FI "IMAGENAME eq mysqld.exe" | find "mysqld.exe" > nul && ECHO.Mysql already run && PAUSE && GOTO MENU
IF NOT EXIST %MYSQL_DIR%/bin/mysqld.exe ECHO %MYSQL_DIR%mysqld.exe command is not exist
%MYSQL_PATH% 
cd %MYSQL_DIR% 
IF EXIST %MYSQL_DIR% start %MYSQL_DIR%/bin/mysqld.exe
tasklist /FI "IMAGENAME eq mysqld.exe" | find "mysqld.exe" > nul && ECHO Start OK
tasklist /FI "IMAGENAME eq mysqld.exe" | find "No tasks" > nul && ECHO.Mysql Start Faild. Please see the Mysql error Log
PAUSE 
GOTO MENU 
:cmd2 
ECHO. 
ECHO.Close Mysql...... 
taskkill /F /IM mysqld.exe > nul 
ECHO.OK 
PAUSE 
GOTO MENU 
:cmd3 
ECHO. 
ECHO.Close Mysql...... 
taskkill /F /IM mysqld.exe > nul 
ECHO.OK 
GOTO cmd1 
GOTO MENU