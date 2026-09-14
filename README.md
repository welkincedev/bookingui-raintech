# Hotel Room Booking App 🏨

A responsive single-page Flutter application built for web, mobile (iOS/Android), and desktop platforms to handle hotel room booking and dynamic price calculations.

---

## 🚀 Overview & Key Features

- **📱 Fully Responsive UI**:
  - **Desktop / Web View (Width $\ge$ 768px)**: Split dual-pane view with a 2-column room catalog grid on the left and reservation details/summary on the right.
  - **Mobile / Compact View (Width < 768px)**: Optimized single-column layout with centered constraints.
- **Room Catalog**: Displays available rooms with details including room code, room type, guest capacity, and price per night (₹).
- **Interactive Selection**: Visual state highlight (primary border, checkmark icon, container shading).
- **Date Range Selection**: Native check-in and check-out date pickers.
- **Reactive Price Calculation**: Dynamically computes `numberOfNights` and `Total Price = Nights × Price per Night`.
- **Validation & Error Handling**:
  - Check-in date cannot be in the past ($\text{Check-in} \ge \text{Today}$).
  - Check-out date must be after check-in date ($\text{Check-out} > \text{Check-in}$).
  - Red warning banners and disabled calculations for invalid inputs.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **Platforms**: Web, Android, iOS, Windows, macOS, Linux
- **Architecture**: Responsive `LayoutBuilder` with native `StatefulWidget` reactive state.
- **CI/CD**: GitHub Actions workflow (`.github/workflows/flutter_ci.yml`).

---

## 📋 How to Run

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)

### Run on Mobile / Web / Desktop

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Web (Chrome)
flutter run -d chrome

# 3. Run on Mobile / Desktop
flutter run
```

---

## 🔀 Git Branching & Commit Workflow

This project adheres to a clean, feature-branch Git workflow:

```bash
# 1. Clone repository
git clone https://github.com/your-username/hotel_booking.git
cd hotel_booking

# 2. Create and checkout a new feature branch
git checkout -b feature/responsive-ui

# 3. Make changes and check status
git status

# 4. Stage and commit changes using conventional commits
git add .
git commit -m "feat: add responsive layout builder for web and mobile devices"

# 5. Push branch to remote
git push -u origin feature/responsive-ui

# 6. Merge back into main branch
git checkout main
git merge feature/responsive-ui
git push origin main
```

---

## 📝 Commit History

1. `feat: initialize flutter project structure and room data model with mock dataset`
2. `feat: build basic UI layout with date picker triggers, room list, and summary card placeholder`
3. `feat: implement reactive state management for dates and room selection with price calculation logic`
4. `feat: add date validation constraints and red error state UI indicators`
5. `docs: add professional README with setup instructions and future enhancements`
6. `feat: introduce responsive LayoutBuilder for Web and Mobile with GitHub Actions CI workflow`
