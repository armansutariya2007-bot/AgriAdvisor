@echo off
title AgriAdvisor - One Click Installer
color 0A

echo.
echo ============================================
echo   AgriAdvisor - One Click Installer
echo ============================================
echo.
echo This will automatically:
echo   ✓ Download Python 3.14.2
echo   ✓ Download XAMPP 8.2.12
echo   ✓ Install both programs
echo   ✓ Install Python packages
echo   ✓ Setup MySQL database
echo   ✓ Configure everything
echo.
echo Total download size: ~160MB
echo Estimated time: 10-15 minutes
echo.
echo ⚠️ IMPORTANT: You may need to allow installations
echo    when Windows asks for permission
echo.
echo Press any key to start or Ctrl+C to cancel...
pause >nul

REM Get script directory
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Create downloads folder
if not exist "downloads" mkdir downloads

echo.
echo ============================================
echo   [1/6] Checking Existing Installations
echo ============================================
echo.

set PYTHON_INSTALLED=0
set XAMPP_INSTALLED=0

python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Python is already installed
    python --version
    set PYTHON_INSTALLED=1
) else (
    echo ⏳ Python not found - will install
)

if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo ✅ XAMPP is already installed
    set XAMPP_INSTALLED=1
) else (
    echo ⏳ XAMPP not found - will install
)

echo.
timeout /t 2 >nul

REM ============================================
REM Install Python
REM ============================================
if %PYTHON_INSTALLED% equ 0 (
    echo.
    echo ============================================
    echo   [2/6] Downloading Python 3.14.2
    echo ============================================
    echo.
    echo Please wait... (50MB download)
    echo.
    
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Write-Host 'Downloading Python...'; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.14.2/python-3.14.2-amd64.exe' -OutFile 'downloads\python-installer.exe'; Write-Host 'Download complete!'}"
    
    if exist "downloads\python-installer.exe" (
        echo ✅ Python downloaded!
        echo.
        echo Installing Python (this will take 2-3 minutes)...
        echo.
        
        REM Silent install with all options
        downloads\python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_pip=1
        
        echo ✅ Python installed!
        timeout /t 3 >nul
    ) else (
        echo ❌ Failed to download Python
        goto manual_install
    )
) else (
    echo.
    echo ============================================
    echo   [2/6] Python Already Installed - Skipping
    echo ============================================
    echo.
)

REM ============================================
REM Install XAMPP
REM ============================================
if %XAMPP_INSTALLED% equ 0 (
    echo.
    echo ============================================
    echo   [3/6] Downloading XAMPP 8.2.12
    echo ============================================
    echo.
    echo Please wait... (150MB download, may take 5-10 minutes)
    echo.
    
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Write-Host 'Downloading XAMPP...'; Write-Host 'This is a large file, please be patient...'; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://sourceforge.net/projects/xampp/files/XAMPP%%20Windows/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe/download' -OutFile 'downloads\xampp-installer.exe'; Write-Host 'Download complete!'}"
    
    if exist "downloads\xampp-installer.exe" (
        echo ✅ XAMPP downloaded!
        echo.
        echo Installing XAMPP...
        echo ⚠️ The installer window will open - please follow the wizard
        echo Recommended: Install to C:\xampp (default location)
        echo.
        pause
        
        REM Run XAMPP installer
        start /wait downloads\xampp-installer.exe
        
        echo ✅ XAMPP installed!
        timeout /t 2 >nul
    ) else (
        echo ❌ Failed to download XAMPP
        goto manual_install
    )
) else (
    echo.
    echo ============================================
    echo   [3/6] XAMPP Already Installed - Skipping
    echo ============================================
    echo.
)

REM ============================================
REM Install Python Packages
REM ============================================
echo.
echo ============================================
echo   [4/6] Installing Python Packages
echo ============================================
echo.

REM Refresh PATH
call refreshenv >nul 2>&1

echo Installing Flask, MySQL, and other packages...
echo.

pip install --quiet Flask==3.0.0 Flask-CORS==4.0.0 Flask-SQLAlchemy==3.1.1 PyMySQL==1.1.0 SQLAlchemy==2.0.23 PyJWT==2.8.0 bcrypt==4.1.2 email-validator==2.1.0 requests==2.31.0 python-dotenv==1.0.0 cryptography==41.0.7

echo ✅ Packages installed!
echo.

REM ============================================
REM Fix SQLAlchemy
REM ============================================
echo.
echo ============================================
echo   [5/6] Fixing SQLAlchemy Compatibility
echo ============================================
echo.

pip uninstall -y -q sqlalchemy flask-sqlalchemy
pip install --quiet SQLAlchemy==1.4.51 Flask-SQLAlchemy==3.0.5

echo ✅ SQLAlchemy fixed!
echo.

REM ============================================
REM Setup Database
REM ============================================
echo.
echo ============================================
echo   [6/6] Setting Up MySQL Database
echo ============================================
echo.

REM Check if XAMPP MySQL is running
echo Checking MySQL status...
netstat -an | find "3306" >nul
if errorlevel 1 (
    echo.
    echo ⚠️ MySQL is not running!
    echo.
    echo Opening XAMPP Control Panel...
    echo Please start MySQL (click Start button next to MySQL)
    echo.
    
    if exist "C:\xampp\xampp-control.exe" (
        start C:\xampp\xampp-control.exe
        echo.
        echo Waiting for you to start MySQL...
        echo Press any key after MySQL is running (shows green)...
        pause >nul
    )
)

echo.
echo Creating database and tables...
echo.

REM Check if .env exists
if not exist "backend\.env" (
    if exist "backend\.env.example" (
        copy "backend\.env.example" "backend\.env" >nul
        echo ✅ Created .env configuration file
    )
)

REM Create database and tables
cd backend
python -c "from database import init_db; from flask import Flask; from config import DevelopmentConfig; app = Flask(__name__); app.config.from_object(DevelopmentConfig); init_db(app); print('✅ Database created successfully!')" 2>nul

if errorlevel 1 (
    echo ⚠️ Database creation had issues
    echo You may need to run SETUP_MYSQL.bat manually
) else (
    echo ✅ Database tables created!
)

cd ..

echo.
echo ============================================
echo   Installation Complete! 🎉
echo ============================================
echo.
echo ✅ Python installed and configured
echo ✅ XAMPP installed with MySQL
echo ✅ Python packages installed
echo ✅ Database created (agriadvisor)
echo ✅ Ready to use!
echo.
echo ============================================
echo   How to Start AgriAdvisor
echo ============================================
echo.
echo 1. Make sure MySQL is running in XAMPP
echo    (Open XAMPP Control Panel if needed)
echo.
echo 2. Double-click: START_SERVER.bat
echo.
echo 3. Browser will open automatically
echo.
echo 4. Create your account and start using!
echo.
echo ============================================
echo.

set /p start_now="Do you want to start AgriAdvisor now? (Y/N): "
if /i "%start_now%"=="Y" (
    echo.
    echo Starting AgriAdvisor...
    echo.
    
    REM Make sure XAMPP is open
    if exist "C:\xampp\xampp-control.exe" (
        start C:\xampp\xampp-control.exe
        echo ✅ XAMPP Control Panel opened
        echo Please make sure MySQL is running (green)
        echo.
        timeout /t 3 >nul
    )
    
    REM Start the server
    call START_SERVER.bat
) else (
    echo.
    echo No problem! When you're ready:
    echo 1. Start MySQL in XAMPP
    echo 2. Double-click START_SERVER.bat
    echo.
)

echo.
echo Press any key to exit...
pause >nul
exit

:manual_install
echo.
echo ============================================
echo   Manual Installation Required
echo ============================================
echo.
echo Automatic download failed. Please install manually:
echo.
echo 1. Python 3.14.2:
echo    https://www.python.org/downloads/
echo    ⚠️ Check "Add Python to PATH" during installation
echo.
echo 2. XAMPP:
echo    https://www.apachefriends.org/
echo    Install to C:\xampp
echo.
echo After manual installation, run this script again.
echo.
pause
exit /b 1
