@echo off
title AgriAdvisor - Complete MySQL Setup & Start
color 0A

echo.
echo ============================================
echo   AgriAdvisor - Complete MySQL Setup
echo ============================================
echo.
echo This script will:
echo   1. Fix SQLAlchemy compatibility
echo   2. Setup MySQL database
echo   3. Start the backend server
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================
echo   [1/3] Fixing SQLAlchemy Compatibility
echo ============================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Python is not installed or not in PATH
    echo.
    echo Please install Python 3.8+ from: https://www.python.org/
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

echo Python found:
python --version
echo.

echo Uninstalling incompatible SQLAlchemy versions...
pip uninstall -y sqlalchemy flask-sqlalchemy >nul 2>&1

echo.
echo Installing compatible versions...
echo   - SQLAlchemy 1.4.51
echo   - Flask-SQLAlchemy 3.0.5
echo.

pip install SQLAlchemy==1.4.51 Flask-SQLAlchemy==3.0.5

echo.
echo Verifying installation...
python -c "import sqlalchemy; print('✅ SQLAlchemy version:', sqlalchemy.__version__)"
python -c "import flask_sqlalchemy; print('✅ Flask-SQLAlchemy version:', flask_sqlalchemy.__version__)"

echo.
echo ✅ SQLAlchemy compatibility fixed!
timeout /t 2 >nul

echo.
echo ============================================
echo   [2/3] Setting Up MySQL Database
echo ============================================
echo.

REM Check if backend directory exists
if not exist "backend" (
    echo ❌ ERROR: backend directory not found
    echo Please run this script from the project root directory
    echo Current directory: %CD%
    echo.
    pause
    exit /b 1
)

echo Installing required Python packages...
echo.

REM Install all required packages
pip install Flask==3.0.0 Flask-CORS==4.0.0 PyMySQL==1.1.0 PyJWT==2.8.0 bcrypt==4.1.2 email-validator==2.1.0 requests==2.31.0 python-dotenv==1.0.0 cryptography==41.0.7

echo.
echo ✅ Packages installed!
echo.

REM Check if .env file exists
if not exist "backend\.env" (
    echo Creating .env configuration file...
    if exist "backend\.env.example" (
        copy "backend\.env.example" "backend\.env" >nul
        echo ✅ .env file created from template
    ) else (
        echo ⚠️ WARNING: .env.example not found
        echo Creating basic .env file...
        (
            echo # MySQL Configuration
            echo MYSQL_HOST=localhost
            echo MYSQL_PORT=3306
            echo MYSQL_USER=root
            echo MYSQL_PASSWORD=
            echo MYSQL_DATABASE=agriadvisor
            echo.
            echo # Email Configuration
            echo SMTP_SERVER=smtp.gmail.com
            echo SMTP_PORT=587
            echo SMTP_EMAIL=your_email@gmail.com
            echo SMTP_PASSWORD=your_app_password
            echo.
            echo # Security
            echo JWT_SECRET=your-secret-key-change-in-production
            echo SECRET_KEY=flask-secret-key
            echo.
            echo # Application
            echo FLASK_ENV=development
            echo DEBUG=True
        ) > "backend\.env"
        echo ✅ Basic .env file created
    )
    echo.
    echo ⚠️ IMPORTANT: Edit backend\.env with your MySQL credentials
    echo.
    set /p edit_env="Do you want to edit .env file now? (Y/N): "
    if /i "%edit_env%"=="Y" notepad "backend\.env"
)

echo.
echo MySQL Server Setup
echo.
echo Please ensure:
echo   1. XAMPP is installed
echo   2. MySQL service is running in XAMPP Control Panel
echo.

REM Check if MySQL is running
netstat -an | find "3306" >nul
if errorlevel 1 (
    echo ⚠️ WARNING: MySQL doesn't appear to be running on port 3306
    echo.
    echo Please start MySQL in XAMPP Control Panel
    echo.
    set /p open_xampp="Do you want to open XAMPP Control Panel? (Y/N): "
    if /i "%open_xampp%"=="Y" (
        if exist "C:\xampp\xampp-control.exe" (
            start C:\xampp\xampp-control.exe
            echo.
            echo ✅ XAMPP Control Panel opened
            echo Please click "Start" next to MySQL
            echo.
            echo Press any key after MySQL is running...
            pause >nul
        ) else (
            echo ❌ XAMPP not found at C:\xampp
            echo Please install XAMPP from: https://www.apachefriends.org/
            echo.
            pause
            exit /b 1
        )
    )
) else (
    echo ✅ MySQL is running on port 3306
)

echo.
echo Creating database and tables...
echo.

cd backend

REM Create database and tables
python -c "from database import init_db; from flask import Flask; from config import DevelopmentConfig; app = Flask(__name__); app.config.from_object(DevelopmentConfig); init_db(app); print('✅ Database initialized successfully!')"

if errorlevel 1 (
    echo.
    echo ❌ ERROR: Failed to create database tables
    echo.
    echo Common issues:
    echo   1. MySQL server not running
    echo   2. Wrong password in backend\.env file
    echo   3. Database 'agriadvisor' doesn't exist
    echo.
    echo Troubleshooting:
    echo   - Start MySQL in XAMPP Control Panel
    echo   - Check backend\.env file credentials
    echo   - Create database manually in phpMyAdmin
    echo.
    cd ..
    pause
    exit /b 1
)

cd ..

echo.
echo ✅ Database setup completed!
echo.
echo Database created with 8 tables:
echo   ✓ users (user accounts)
echo   ✓ otps (verification codes)
echo   ✓ crops (crop records)
echo   ✓ irrigation_records (water management)
echo   ✓ farm_transactions (financial data)
echo   ✓ market_prices (price data)
echo   ✓ login_history (activity logs)
echo   ✓ equipment_bookings (rental bookings)
echo.

timeout /t 2 >nul

echo.
echo ============================================
echo   [3/3] Starting Backend Server
echo ============================================
echo.

set /p start_server="Do you want to start the backend server now? (Y/N): "
if /i not "%start_server%"=="Y" goto end_setup

echo.
echo Starting AgriAdvisor Backend Server...
echo.
echo Server will be available at:
echo   - Frontend: http://localhost:5000
echo   - API: http://localhost:5000/api/*
echo.
echo Database: MySQL (agriadvisor)
echo.
echo Opening website in 3 seconds...
echo Press Ctrl+C to stop the server
echo.

REM Start backend server in background
cd backend
start /B python app_mysql.py

REM Wait for server to start
timeout /t 3 /nobreak >nul

REM Open website in default browser
start http://localhost:5000

REM Keep window open to show server logs
echo.
echo ============================================
echo   Website opened in browser!
echo ============================================
echo.
echo ✅ Backend server is running...
echo ✅ Check browser at: http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

REM Wait indefinitely to keep server running
pause

goto end

:end_setup
echo.
echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo To start the server later:
echo   1. Make sure MySQL is running in XAMPP
echo   2. Double-click: START_SERVER.bat
echo.
echo To view database:
echo   1. Start Apache in XAMPP
echo   2. Open: http://localhost/phpmyadmin
echo   3. Click "agriadvisor" database
echo.

:end
echo.
echo Press any key to exit...
pause >nul
