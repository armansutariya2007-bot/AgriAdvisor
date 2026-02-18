@echo off
title AgriAdvisor - Backend Server
color 0A

echo.
echo ============================================
echo   AgriAdvisor - Backend Server
echo ============================================
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://www.python.org/
    pause
    exit /b 1
)

REM Check if backend directory exists
if not exist "backend" (
    echo ERROR: backend directory not found
    echo Please run this script from the project root directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

REM Check if .env file exists
if not exist "backend\.env" (
    echo.
    echo WARNING: .env file not found
    echo.
    echo Please run SETUP_MYSQL.bat first to configure the database
    echo.
    pause
    exit /b 1
)

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

REM Start backend server in background and wait 3 seconds
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
echo Backend server is running...
echo Check browser at: http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

REM Wait indefinitely to keep server running
pause
