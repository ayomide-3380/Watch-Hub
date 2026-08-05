# WatchHub Backend

Spring Boot REST API powering the WatchHub app — handles authentication,
the watch catalog, cart, wishlist, orders, and the admin portal.

## Tech stack

- Java 17
- Spring Boot 4.1 (Web, Data JPA, Security, Validation)
- MySQL
- Maven (via the included `mvnw` wrapper — no local Maven install needed)

## Prerequisites

- JDK 17+
- MySQL Server running locally (or update the connection URL to point
  elsewhere)

## Setup

### 1. Create a MySQL user (or use an existing one)

The app will create the `watchhub` database automatically on first run
(`createDatabaseIfNotExist=true`), but the MySQL **user** needs to already
exist with the right privileges:

```sql
CREATE USER 'watchhub_user'@'localhost' IDENTIFIED BY 'your_password_here';
GRANT ALL PRIVILEGES ON watchhub.* TO 'watchhub_user'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Set your database credentials as environment variables

Credentials are **not** hardcoded in `application.yaml` — they're read from
environment variables, so nothing sensitive ever gets committed to git.

**PowerShell (per session):**
```powershell
$env:DB_USERNAME="watchhub_user"
$env:DB_PASSWORD="your_password_here"
```

**Or permanently, via System Environment Variables** (Windows: search "Edit
the system environment variables" → Environment Variables → New, under User
variables), so you don't have to set them every terminal session.

**In IntelliJ:** Run → Edit Configurations → select your Spring Boot run
config → Environment variables → add `DB_USERNAME` and `DB_PASSWORD` there.
This way it works from the IntelliJ Run button too, not just the terminal.

### 3. Run the server

```powershell
./mvnw.cmd clean spring-boot:run
```

The API will start on `http://localhost:8080`, with all endpoints under
`/api`.

## Notable endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/register` | Create an account |
| POST | `/api/auth/login` | Log in |
| GET / PATCH | `/api/users/{id}` | Fetch / update a user profile |
| GET | `/api/watches` | List all watches |
| GET / POST / PATCH / DELETE | `/api/cart/...` | Cart operations |
| GET / POST / DELETE | `/api/wishlist/...` | Wishlist operations |
| POST | `/api/orders` | Checkout |
| GET | `/api/orders/{userId}` | A user's own order history |
| GET | `/api/orders/all` | **Admin:** every order, all users |
| PATCH | `/api/orders/{id}/status` | **Admin:** update order status |

## Notes on admin access

Admin status is controlled by an `is_admin` column on the `users` table.
There's no self-service way to become an admin (by design) — to make an
account an admin, update it directly in the database:

```sql
UPDATE users SET is_admin = 1 WHERE email = 'your-admin-email@example.com';
```

The frontend hides all admin UI from non-admin accounts, but be aware the
backend endpoints above don't currently enforce this server-side — they rely
on the frontend not exposing them to regular users. Worth noting as a known
limitation / future improvement in project documentation.

## Known limitations

- No JWT/session-based auth — the backend doesn't verify who's making a
  request beyond what the frontend sends. Fine for a school project demo,
  not production-ready.
- Reviews and customer support are frontend-only mock data — no backend
  endpoints exist for them yet.
