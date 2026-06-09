@echo off
setlocal
chcp 65001 > nul

cls
echo ===========================================
echo        [Auto Push] Git repository          
echo ===========================================
echo.

git rev-parse --git-dir >nul 2>&1

if %errorlevel% neq 0 (
    echo -------------------------------------------
    echo  [ERROR] Current directory is not a Git repository.
    pause
    goto QUIT
)

git pull origin main
git add .

set "msg="
set /p msg="Commit message? : "

if not defined msg (
    set "current_time=%time: =0%"
    call set "msg=[Auto] %%date%% %%current_time:~0,5%%"
)

git commit -m "%msg%"

if %errorlevel% neq 0 (
    echo  [Error] Nothing to commit.
    pause
    goto QUIT
)

git push origin main

:QUIT
echo.
echo  [Exit] End git-pushlazy process...
timeout /t 2 >nul
cmd /k