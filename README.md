# 🌾 AgriFlow

A farm management system built with **Flutter** (mobile/web) and **PHP + MySQL** (backend). AgriFlow helps farmers manage their farms, crops, expenses, and harvests — while giving admins a dashboard to oversee everything.

---

## ✨ Features

### Authentication
- Login (username or email)
- Signup with full name, email, username, password
- Forgot password screen
- Role-based routing (admin → admin dashboard, farmer → farmer dashboard)

### Farmer Dashboard
- **Home** — real-time stats (farms, crops, expenses, harvests), recent crops, quick actions
- **My Farms** — view all farms, add new farm (name, location, size)
- **My Crops** — view all crops with status badges, add crop (select farm, set dates, status)
- **Reports** — per-farm expense reports from the database
- Pull-to-refresh on all screens

### Admin Dashboard
- **Overview** — system-wide stats (total farmers, farms, crops, harvests), recent activity feed
- **User Management** — list all users with role badges and farm counts
- **Farm Management** — all farms with owner info, location, crop count
- **Crop Monitoring** — all crops with status, farm name, owner
- **Reports & Analytics** — summary cards + per-farm breakdown (crops, expenses, harvests)
- **Settings** — app settings page (placeholder)
- Drawer + bottom navigation

### Backend (PHP API)
- All data is dynamic — fetched from MySQL via REST endpoints
- Prepared statements for security
- CORS headers for cross-origin requests
- `setup_database.php` — works like `migrate:fresh --seed` (drops and recreates all tables)

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── models/
│   ├── user.dart
│   ├── farm.dart
│   └── crop.dart
├── services/
│   ├── api_services.dart        # All HTTP calls (farmer + admin)
│   ├── auth_service.dart
│   └── database_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── forgot_password_screen.dart
│   ├── dashboard_screen.dart    # Farmer shell (bottom nav)
│   ├── farmer/
│   │   ├── farmer_home.dart     # Stats, recent crops, quick actions
│   │   ├── farmer_farms.dart    # Farm list + add farm
│   │   ├── farmer_crops.dart    # Crop list + add crop
│   │   └── farmer_reports.dart  # Expense reports
│   └── admin/
│       ├── admin_dashboard.dart # Admin shell (drawer + bottom nav)
│       ├── admin_overview.dart  # Stats + activity feed
│       ├── admin_users.dart     # User list
│       ├── admin_farms.dart     # Farm list
│       ├── admin_crops.dart     # Crop list
│       ├── admin_reports.dart   # Reports + analytics
│       └── admin_settings.dart  # Settings
└── widgets/
    └── custom_button.dart

php_backend/agriflow_api/
├── config.php                   # DB credentials
├── db_connect.php               # DB connection
├── setup_database.php           # migrate:fresh --seed
├── setup.sql                    # SQL schema reference
├── login.php                    # Login (username or email)
├── signup.php                   # Register new user
├── add_farm.php                 # Add farm
├── add_crop.php                 # Add crop
├── add_expense.php              # Add expense
├── get_farms.php                # Get user's farms
├── get_crops.php                # Get user's crops
├── get_dashboard_stats.php      # Farmer dashboard stats
├── get_reports.php              # Farmer reports
├── admin_stats.php              # Admin overview stats + activity
├── admin_get_users.php          # All users
├── admin_get_farms.php          # All farms
├── admin_get_crops.php          # All crops
└── admin_get_reports.php        # Admin reports + summary
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.11+)
- [XAMPP](https://www.apachefriends.org/) (Apache + MySQL)
- Git
- Android device or emulator (for mobile), or Chrome (for web)

### 1. Clone the Repository

```bash
git clone https://github.com/lykajenille/AgriFlow.git
cd AgriFlow
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Set Up the PHP Backend

1. Start **XAMPP** (Apache + MySQL)
2. Copy or symlink the API folder to htdocs:

   **Windows (symlink):**
   ```powershell
   # Run as Administrator
   New-Item -ItemType SymbolicLink -Path "C:\xampp\htdocs\agriflow_api" -Target "<your-path>\AgriFlow\php_backend\agriflow_api"
   ```

   **Or just copy:**
   ```powershell
   Copy-Item -Recurse "php_backend\agriflow_api" "C:\xampp\htdocs\agriflow_api"
   ```

3. Run the database setup (creates the `agriflow` database + tables + demo users):
   - Open your browser and go to: `http://localhost/agriflow_api/setup_database.php`
   - You should see a JSON success response

### 4. Configure API URL

In `lib/services/api_services.dart`, update the IP address for physical device testing:

```dart
// For physical Android device — use your computer's local IP
return "http://<YOUR-LOCAL-IP>/agriflow_api";
```

Find your IP:
```powershell
ipconfig | findstr /i "IPv4"
```

> For web testing, it uses `localhost` automatically.

### 5. Run the App

**Web:**
```bash
flutter run -d web-server --web-port=8080
```

**Android (physical device via USB):**
```bash
flutter run -d <device-id>
```

Find your device ID:
```bash
flutter devices
```

---

## 🔑 Demo Accounts

After running `setup_database.php`:

| Role | Username | Password |
|------|----------|----------|
| Admin | `admin` | `admin123` |
| Farmer | `farmer` | `1234` |

---

## 🗄️ Database

**Name:** `agriflow`

**Tables:**
| Table | Description |
|-------|-------------|
| `users` | User accounts (admin/farmer) |
| `farms` | Farms linked to users |
| `crops` | Crops linked to farms |
| `inventory` | Farm inventory items |
| `expenses` | Farm expenses |
| `harvests` | Harvest records |

To reset the database (drop everything and reseed):
```
http://localhost/agriflow_api/setup_database.php
```

---

## 🛠️ Tech Stack

- **Frontend:** Flutter / Dart
- **Backend:** PHP (vanilla)
- **Database:** MySQL (via XAMPP)
- **HTTP:** `http` package for REST calls

---

## 👥 Contributors

- [lykajenille](https://github.com/lykajenille)
- [GinxSirr](https://github.com/GinxSirr)
