# AgriAdvisor - Smart Farming Solution

Agricultural management platform with MySQL database, AI-powered crop recommendations, and real-time market prices.

---

## 🚀 Complete Setup Guide (From Scratch)

### Prerequisites to Download:

**1. Python 3.8+**
- Download: https://www.python.org/downloads/
- ✅ IMPORTANT: Check "Add Python to PATH" during installation
- Verify: `python --version`

**2. XAMPP (MySQL Server)**
- Download: https://www.apachefriends.org/
- Install components: Apache, MySQL, phpMyAdmin
- Install to: `C:\xampp`
- Start MySQL in XAMPP Control Panel

---

## Quick Start

### Method 1: One-Click Install (Easiest - For Beginners)
```cmd
ONE_CLICK_INSTALL.bat
```
- Downloads Python & XAMPP automatically
- Installs everything
- Sets up database
- Starts application
- Total time: 10-15 minutes

### Method 2: All-in-One Setup (After Manual Install)
```cmd
COMPLETE_MYSQL_SETUP.bat
```
- Fixes package compatibility
- Installs Python packages
- Creates MySQL database
- Starts backend server
- Use after installing Python & XAMPP manually

### Method 3: Daily Use (After Setup)
```cmd
START_SERVER.bat
```
- Quick start for daily use
- Opens browser automatically at http://localhost:5000

---

## Daily Usage

**Every time you want to use:**
1. Start MySQL in XAMPP
2. Double-click `START_SERVER.bat`
3. Browser opens automatically
4. Login and use!

---

## View Database Data (phpMyAdmin)

1. **Start Apache in XAMPP** (if not running)
2. **Open browser**: http://localhost/phpmyadmin
3. **Click "agriadvisor"** database in left sidebar
4. **Click any table** (users, crops, etc.)
5. **Click "Browse" tab** to see data

---

## Files

### 🚀 Installation & Setup Files
- **ONE_CLICK_INSTALL.bat** - Complete automatic installation (downloads & installs everything)
- **COMPLETE_MYSQL_SETUP.bat** - All-in-one MySQL setup (fix packages + setup DB + start server)
- **INSTALL_REQUIREMENTS.bat** - Download and install Python & XAMPP
- **START_SERVER.bat** - Start the application (use daily)

### 📚 Documentation Files
- **README.md** - Project overview (this file)
- **PROJECT_SUMMARY.txt** - Quick project summary
- **FINAL_SUMMARY.txt** - Complete documentation
- **QUICK_START_GUIDE.txt** - Quick reference guide
- **INSTALLER_README.txt** - Installer guide
- **TECHNOLOGY_STACK.txt** - Technologies used

### Backend Files
- `backend/app_mysql.py` - Main backend application (20 API endpoints)
- `backend/config.py` - Configuration
- `backend/models.py` - Database models (8 tables)
- `backend/database.py` - Database initialization
- `backend/crop_recommendation_helper.py` - Crop recommendation logic
- `backend/.env` - MySQL credentials

---

## Database Tables

1. **users** - User accounts and authentication
2. **otps** - OTP verification codes
3. **crops** - Crop management records
4. **irrigation_records** - Irrigation activity logs
5. **farm_transactions** - Financial transactions
6. **market_prices** - Market price data
7. **login_history** - User activity tracking
8. **equipment_bookings** - Equipment rental bookings

---

## Configuration

Edit `backend/.env`:
```env
# MySQL Database
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=
MYSQL_DATABASE=agriadvisor

# Email (Gmail SMTP)
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_EMAIL=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# Security
JWT_SECRET=your_secret_key
SECRET_KEY=flask_secret_key

# Application
FLASK_ENV=development
DEBUG=True
```

---

## Features

- ✅ User registration with email OTP verification
- ✅ JWT authentication
- ✅ Crop management (CRUD operations)
- ✅ AI-powered crop recommendations (12+ crops)
- ✅ Irrigation tracking and management
- ✅ Equipment booking system
- ✅ Real-time market prices
- ✅ Government schemes information
- ✅ Pest detection with treatment recommendations
- ✅ User profile management
- ✅ Admin analytics dashboard

---

## API Endpoints (20 Total)

### Authentication (8 endpoints)
- User registration, login, OTP verification
- Password reset, profile management

### Crop Management (5 endpoints)
- CRUD operations for crops
- AI-powered recommendations

### Irrigation (2 endpoints)
- Track water usage and schedules

### Services (3 endpoints)
- Equipment booking
- Market prices
- Government schemes

### Pest Detection (1 endpoint)
- Identify pests and get treatments

### Admin (1 endpoint)
- Database statistics

---

## Troubleshooting

**SQLAlchemy error:**
```cmd
FIX_SQLALCHEMY.bat
```

**Can't connect to MySQL:**
- Start MySQL in XAMPP
- Check `backend/.env` credentials
- Create database: `CREATE DATABASE agriadvisor;`

**Can't access phpMyAdmin:**
- Start Apache in XAMPP
- Open: http://localhost/phpmyadmin

**No data in tables:**
- Tables are empty until you use the application
- Register a user and use features
- Data will be saved to MySQL automatically

---

## Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript, Tailwind CSS
- **Backend**: Python Flask, SQLAlchemy
- **Database**: MySQL 5.7+ (fully database-driven)
- **Authentication**: JWT, bcrypt, OTP
- **APIs**: Open-Meteo Weather, Government Market Prices

---

**Version 2.0** | Fully MySQL-Based | Production Ready ✅

🌾 AgriAdvisor - Empowering Farmers with Technology
