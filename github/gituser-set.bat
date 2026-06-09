@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:INPUT_LOOP
cls
echo ===========================================
echo       [Set] Git Local User Settings          
echo ===========================================
echo  * To quit, press "Enter" without typing, 
echo    or type "q" / "exit".
echo ===========================================
echo.

:: >> Check Inside .git Directory

if not exist ".git" (
    echo -------------------------------------------
    echo  [Error] This directory is not a Git repository.
    echo         Please run this batch inside a Git repository.
    echo.
    pause
    goto QUIT
)

:: >> Input User name / Email address

set "GIT_USER_NAME="
set /p GIT_USER_NAME="Username? : "

if "%GIT_USER_NAME%"=="" goto QUIT
if /i "%GIT_USER_NAME%"=="q" goto QUIT
if /i "%GIT_USER_NAME%"=="exit" goto QUIT

set "GIT_USER_EMAIL="
set /p GIT_USER_EMAIL="Email?    : "

if "%GIT_USER_EMAIL%"=="" goto QUIT
if /i "%GIT_USER_EMAIL%"=="q" goto QUIT
if /i "%GIT_USER_EMAIL%"=="exit" goto QUIT

:: >> Execute git config / Check status

echo.
git config --local user.name "%GIT_USER_NAME%" 2>nul
git config --local user.email "%GIT_USER_EMAIL%" 2>nul

if %errorlevel% neq 0 (
    echo -------------------------------------------
    echo  [Error] Failed to set Git configurations.
    echo          Is Git installed and accessible in your PATH?
    echo.
    pause
    goto INPUT_LOOP
)
echo -------------------------------------------
echo  [Success] Configured local settings successfully.
echo    - user.name  : !GIT_USER_NAME!
echo    - user.email : !GIT_USER_EMAIL!
echo.
pause
goto QUIT

:QUIT
echo.
echo  [Exit] End gituser-set process...
timeout /t 2 >nul
cmd /k