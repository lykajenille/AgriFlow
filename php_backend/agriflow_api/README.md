# AgriFlow PHP Backend - Login API

This is the PHP backend for the AgriFlow Flutter application. It handles user authentication via the `/login.php` endpoint.

## Setup Instructions

### 1. Database Setup
- Open phpMyAdmin or your MySQL client
- Run the `setup.sql` script to create the database and tables
- This creates a `users` table with sample test users

### 2. Server Configuration
- Copy the entire `agriflow_api` folder to your web server's root directory:
  - **XAMPP**: `C:\xampp\htdocs\agriflow_api\`
  - **WAMP**: `C:\wamp\www\agriflow_api\`
  - **LAMP**: `/var/www/html/agriflow_api/`

### 3. Update Configuration
Edit `config.php` with your database credentials:
```php
define('DB_HOST', 'localhost');    // Your database host
define('DB_USER', 'root');         // Your database user
define('DB_PASS', '');             // Your database password
define('DB_NAME', 'agriflow');     // Your database name
```

### 4. Update Flutter App
In your Flutter app's `login_screen.dart`, update the API URL if needed:
```dart
var url = Uri.parse('http://localhost/agriflow_api/login.php');
```

## API Endpoints

### Login
**POST** `/login.php`

**Parameters:**
- `username` (string, required)
- `password` (string, required)

**Success Response (200):**
```json
{
    "success": true,
    "message": "Login successful",
    "user": {
        "id": 1,
        "username": "admin",
        "email": "admin@agriflow.com",
        "full_name": "Admin User",
        "role": "admin"
    },
    "token": "abc123xyz..."
}
```

**Error Response (401):**
```json
{
    "success": false,
    "message": "Invalid username or password"
}
```

## Test Users

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | admin |
| farmer | 1234 | farmer |

## Security Notes

⚠️ **IMPORTANT FOR PRODUCTION:**
1. **Use Password Hashing**: Replace plain text password comparison with `password_hash()` and `password_verify()`
2. **Use HTTPS**: Always use HTTPS in production, not HTTP
3. **Use JWT Tokens**: Implement proper JWT authentication instead of simple tokens
4. **Change Secret Keys**: Update the `JWT_SECRET` in `config.php`
5. **Input Validation**: Add more thorough input validation
6. **Rate Limiting**: Implement login attempt rate limiting
7. **CORS**: Update the CORS policy to your actual domain

## File Structure

```
agriflow_api/
├── config.php          # Database and app configuration
├── db_connect.php      # Database connection
├── login.php           # Login endpoint
├── setup.sql           # Database setup script
└── README.md           # This file
```

## Testing the API

You can test the login endpoint using:
- cURL
- Postman
- Your Flutter app

**cURL Example:**
```bash
curl -X POST http://localhost/agriflow_api/login.php \
  -d "username=admin&password=admin123"
```

## Troubleshooting

### "Database connection failed"
- Check if MySQL is running
- Verify database credentials in `config.php`
- Ensure the database is created

### "Method not allowed"
- Make sure you're using POST request, not GET

### "Username and password are required"
- Verify you're sending both username and password in the request body

## Future Enhancements

Consider adding:
- User registration endpoint
- Password reset functionality
- Password hashing with bcrypt
- JWT token authentication
- Role-based access control (RBAC)
- Email verification
- Two-factor authentication
