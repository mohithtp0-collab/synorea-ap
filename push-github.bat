@echo off
title Push Synorea to GitHub (mottamohith-beep/synorea-ap)
cd /d "%~dp0"

echo ========================================================
echo   Synorea E-Commerce - GitHub Deployment
echo   Target: https://github.com/mottamohith-beep/synorea-ap
echo ========================================================
echo.

:: Ensure Git is in PATH
set "PATH=%PATH%;C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\Program Files (x86)\Git\cmd;%LOCALAPPDATA%\Programs\Git\cmd"

:: Check if git is available
where git >nul 2>&1
if %errorlevel% neq 0 (
  echo [ERROR] Git is not found in your system PATH!
  echo Please download and install Git from: https://git-scm.com/download/win
  echo After installing, run this file again.
  pause
  exit /b 1
)

:: 1. Ensure Git repository is initialized
if not exist ".git" (
  echo [1/6] Initializing local Git repository...
  call git init
) else (
  echo [1/6] Local Git repository detected.
)

:: 2. Configure Git user identity (prevents 'Author identity unknown' error)
echo [2/6] Verifying Git author identity...
git config user.name >nul 2>&1
if %errorlevel% neq 0 (
  call git config user.name "mottamohith-beep"
)
git config user.email >nul 2>&1
if %errorlevel% neq 0 (
  call git config user.email "mottamohith-beep@users.noreply.github.com"
)
call git config credential.helper manager >nul 2>&1

:: 3. Stage project files (respects .gitignore)
echo [3/6] Staging files...
call git add -A

:: 4. Commit changes
echo [4/6] Creating commit...
call git commit -m "Synorea: E-commerce platform with 3D Fashion Runway & German White and Green theme"
if %errorlevel% neq 0 (
  echo [INFO] Working tree clean or commit already up to date.
)

:: 5. Ensure branch is main
echo [5/6] Setting active branch to 'main'...
call git branch -M main

:: 6. Configure remote origin
echo [6/6] Configuring remote origin...
call git remote remove origin >nul 2>&1
call git remote add origin https://github.com/mottamohith-beep/synorea-ap.git
call git remote set-url origin https://github.com/mottamohith-beep/synorea-ap.git

echo.
echo ========================================================
echo   Pushing code to GitHub...
echo ========================================================
echo.

call git push -u origin main

if %errorlevel% equ 0 goto success

:: If rejected due to remote files (e.g. GitHub created with README or license)
echo.
echo [NOTICE] Push was rejected by GitHub.
echo Attempting to synchronize with force-push...
echo.
call git push -u origin main --force

if %errorlevel% equ 0 goto success

:: If still failing, provide diagnostic and help
echo.
echo ========================================================
echo   [PUSH ERROR DIAGNOSTIC]
echo ========================================================
echo.
echo Common reasons for this error:
echo.
echo 1. The repository 'synorea-ap' does not exist yet on your GitHub.
echo    - Open: https://github.com/new
echo    - Set Repository Name: synorea-ap
echo    - Leave 'Add a README' UNCHECKED
echo    - Click 'Create repository'
echo.
echo 2. Authentication:
echo    - When prompted, sign in via browser with your GitHub account.
echo    - If asking for password, use a GitHub Personal Access Token (PAT):
echo      https://github.com/settings/tokens (select 'repo' scope).
echo.
echo ========================================================
echo.
set /p OPEN_GH="Would you like to open https://github.com/new in your browser? (y/n): "
if /i "%OPEN_GH%"=="y" (
  start https://github.com/new
)
pause
exit /b 1

:success
echo.
echo ========================================================
echo   SUCCESS! Synorea has been pushed to your GitHub!
echo   Repository: https://github.com/mottamohith-beep/synorea-ap
echo ========================================================
echo.
start https://github.com/mottamohith-beep/synorea-ap
pause
exit /b 0
