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

## 📋 Prerequisites & How to Run

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- Target device / emulator (Chrome, Android Emulator, iOS Simulator, or Desktop)

### Running the App

```bash
# 1. Clone or navigate into project directory
cd hotel_booking

# 2. Install dependencies
flutter pub get

# 3. Run application
flutter run
```

---

## 💡 Future Improvements & Enhancements

Given more development time, the following enhancements could be implemented:

1. **State Management Architecture**: Refactor from inline `setState` to a structured solution like **Riverpod**, **Bloc**, or **Provider** for clean separation of concerns.
2. **Backend & Database Integration**: Connect to a REST API or Firebase backend for real-time room availability, live inventory, and actual booking creation.
3. **Automated Testing**: Add comprehensive unit tests for calculation/validation logic and widget tests for key user flows.
4. **UI & UX Animations**: Add smooth card selection animations, hero transitions, and responsive grid layouts for tablet/desktop screens.
5. **Localization & Currency Conversion**: Add support for multiple currencies, date formatting standardizations, and localized strings.

---

## 📝 Commit History

1. `feat: initialize flutter project structure and room data model with mock dataset`
2. `feat: build basic UI layout with date picker triggers, room list, and summary card placeholder`
3. `feat: implement reactive state management for dates and room selection with price calculation logic`
4. `feat: add date validation constraints and red error state UI indicators`
5. `docs: add professional README with setup instructions and future enhancements`
