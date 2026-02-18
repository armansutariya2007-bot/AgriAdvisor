@echo off
title AgriAdvisor - Automatic Requirements Installer
color 0A

echo.
echo ============================================
echo   AgriAdvisor - Requirements Installer
echo ============================================
echo.
echo This script will automatically download and install:
echo   1. Python 3.14.2 (if not installed)
echo   2. XAMPP 8.2.12 (if not installed)
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Create downloads folder
if not exist "downloads" mkdir downloads

echo.
echo ============================================
echo   Step 1: Checking Python Installation
echo ============================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Python is already installed!
    python --version
    echo.
    set /p reinstall_python="Do you want to reinstall Python? (Y/N): "
    if /i not "%reinstall_python%"=="Y" goto check_xampp
)

echo.
echo Downloading Python 3.14.2...
echo Please wait, this may take a few minutes...
echo.

REM Download Python installer using PowerShell
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.14.2/python-3.14.2-amd64.exe' -OutFile 'downloads\python-installer.exe'}"

if exist "downloads\python-installer.exe" (
    echo ✅ Python downloaded successfully!
    echo.
    echo Installing Python...
    echo ⚠️ IMPORTANT: The installer will open - make sure to check "Add Python to PATH"!
    echo.
    pause
    
    REM Install Python silently with PATH
    start /wait downloads\python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    
    echo.
    echo ✅ Python installation completed!
    echo.
    echo Verifying installation...
    timeout /t 3 >nul
    python --version
    echo.
) else (
    echo ❌ Failed to download Python
    echo Please download manually from: https://www.python.org/downloads/
    echo.
)

:check_xampp
echo.
echo ============================================
echo   Step 2: Checking XAMPP Installation
echo ============================================
echo.

REM Check if XAMPP is installed
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo ✅ XAMPP is already installed at C:\xampp
    echo.
    set /p reinstall_xampp="Do you want to reinstall XAMPP? (Y/N): "
    if /i not "%reinstall_xampp%"=="Y" goto install_packages
)

echo.
echo Downloading XAMPP 8.2.12...
echo Please wait, this may take 5-10 minutes (150MB file)...
echo.

REM Download XAMPP installer using PowerShell
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://sourceforge.net/projects/xampp/files/XAMPP%%20Windows/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe/download' -OutFile 'downloads\xampp-installer.exe'}"

if exist "downloads\xampp-installer.exe" (
    echo ✅ XAMPP downloaded successfully!
    echo.
    echo Installing XAMPP...
    echo The installer will open - follow the installation wizard.
    echo Recommended: Install to C:\xampp (default)
    echo.
    pause
    
    REM Run XAMPP installer
    start /wait downloads\xampp-installer.exe
    
    echo.
    echo ✅ XAMPP installation completed!
    echo.
) else (
    echo ❌ Failed to download XAMPP
    echo Please download manually from: https://www.apachefriends.org/
    echo.
)

:install_packages
echo.
echo ============================================
echo   Step 3: Installing Python Packages
echo ============================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not available in PATH
    echo Please restart your computer and run this script again
    echo Or install Python manually from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Installing required Python packages...
echo This may take a few minutes...
echo.

REM Install packages from requirements file
if exist "backend\requirements_mysql.txt" (
    pip install -r backend\requirements_mysql.txt
) else (
    echo Installing packages individually...
    pip install Flask==3.0.0 Flask-CORS==4.0.0 Flask-SQLAlchemy==3.1.1 PyMySQL==1.1.0 SQLAlchemy==2.0.23 PyJWT==2.8.0 bcrypt==4.1.2 email-validator==2.1.0 requests==2.31.0 python-dotenv==1.0.0 cryptography==41.0.7
)

echo.
echo ✅ Python packages installed!
echo.

echo.
echo ============================================
echo   Step 4: Fixing SQLAlchemy Version
echo ============================================
echo.

echo Downgrading to compatible SQLAlchemy version...
pip uninstall -y sqlalchemy flask-sqlalchemy
pip install SQLAlchemy==1.4.51 Flask-SQLAlchemy==3.0.5

echo.
echo ✅ SQLAlchemy fixed!
echo.

echo.
echo ============================================
echo   Installation Summary
echo ============================================
echo.

REM Check Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Python: Installed
    python --version
) else (
    echo ❌ Python: Not found
)

echo.

REM Check XAMPP
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo ✅ XAMPP: Installed at C:\xampp
) else (
    echo ❌ XAMPP: Not found
)

echo.

REM Check Python packages
python -c "import flask; print('✅ Flask: Installed')" 2>nul || echo ❌ Flask: Not installed
python -c "import pymysql; print('✅ PyMySQL: Installed')" 2>nul || echo ❌ PyMySQL: Not installed

echo.
echo ============================================
echo   Next Steps
echo ============================================
echo.
echo 1. Start XAMPP Control Panel
echo    Location: C:\xampp\xampp-control.exe
echo.
echo 2. Start MySQL in XAMPP
echo    Click "Start" button next to MySQL
echo.
echo 3. Run database setup:
echo    Double-click: SETUP_MYSQL.bat
echo.
echo 4. Start the application:
echo    Double-click: START_SERVER.bat
echo.
echo ============================================
echo   Installation Complete!
echo ============================================
echo.

REM Ask if user wants to start XAMPP
set /p start_xampp="Do you want to start XAMPP Control Panel now? (Y/N)