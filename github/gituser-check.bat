@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

cls
echo ===========================================
echo      [Check] Git Local User Settings          
echo ===========================================
echo.

:: >> Check Inside .git Directory

if not exist ".git" (
    echo -------------------------------------------
    echo  [Error] This directory is not a Git repository.
    echo          Please run this batch inside a Git repository.
    echo.
    pause
    goto QUIT
)

:: >> Verify configured username and email

set "GIT_NAME="
set "GIT_EMAIL="

for /f "delims=" %%i in ('git config --local user.name 2^>nul') do set GIT_NAME=%%i
for /f "delims=" %%i in ('git config --local user.email 2^>nul') do set GIT_EMAIL=%%i

echo.
echo -------------------------------------------
if defined GIT_NAME (
    echo  [OK] user.name  : !GIT_NAME!
) else (
    echo  [NG] user.name is not set.
)

if defined GIT_EMAIL (
    echo  [OK] user.email : !GIT_EMAIL!
) else (
    echo  [NG] user.email is not set.
)
echo.
pause
goto QUIT

:QUIT
echo.
echo  [Exit] End gituser-check process...
timeout /t 2 >nul
cmd /k