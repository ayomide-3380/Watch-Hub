# WatchHub

A premium watch e-commerce mobile app, built as a school eProject. WatchHub lets
customers browse a curated watch catalog, manage a cart and wishlist, check out,
and track orders — with a separate admin portal for managing inventory and
customer orders.

## Repository structure

```
WatchHub/
├── frontend/    Flutter app (iOS, Android, Web, Windows, Linux)
└── backend/     Spring Boot REST API + MySQL
```

## Tech stack

**Frontend:** Flutter (Dart), Provider for state management, `http` for API calls

**Backend:** Spring Boot 4.1, Java 17, Spring Data JPA, Spring Security (password
hashing), MySQL

## Features

- **Authentication** — register, login, profile management
- **Catalog** — browse, search, and filter watches by brand, type, and price
- **Cart** — add/remove/update items, apply promo codes, synced to the backend
- **Wishlist** — favorite watches, organize into custom collections
- **Checkout & Orders** — real checkout flow with tax/shipping calculation,
  order history, order status tracking
- **Loyalty program** — earn points per purchase, automatic VIP tier upgrades
- **Admin portal** — inventory management (add/edit/delete/restock watches),
  view and update customer orders across all users, store analytics.
  Restricted to accounts flagged `isAdmin` in the database — regular users
  never see any entry point to it.
- **Custom watch configurator** — build and order a bespoke watch

> Reviews and customer support chat are currently frontend-only (mock data) —
> not yet wired to the backend.

## Getting started

You'll need both the backend and frontend running for the app to work fully.

### 1. Backend setup

See [`backend/README.md`](backend/README.md) for full setup instructions
(MySQL setup, environment variables, running the server).

### 2. Frontend setup

```bash
cd frontend
flutter pub get
flutter run
```

By default, the app points at `http://localhost:8080/api` (see
`frontend/lib/config/api_config.dart`). If you're running on an Android
emulator, change this to `http://10.0.2.2:8080/api` instead, since the
emulator can't reach the host machine via `localhost`.

## Team

Frontend and backend were developed collaboratively by  **Ayomide Alao, Oluwagbebemi Ososanya, and Azeezat Okunola**
