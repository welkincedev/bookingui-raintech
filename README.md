# Hotel Room Booking App 🏨

A single-page Flutter application built as part of a developer skills assessment for hotel room booking and total cost calculation.

---

## 🚀 Overview & Features

- **Room Catalog**: Displays a list of available rooms with details including room code, room type, max guest capacity, and price per night (₹).
- **Interactive Selection**: Visual state highlight indicating the currently selected room.
- **Date Range Selection**: Native check-in and check-out date pickers.
- **Reactive Price Calculation**: Automatically calculates `numberOfNights` and computes `Total Price = Nights × Price per Night`.
- **Validation & Error Handling**:
  - Check-in date must be on or after today.
  - Check-out date must be after check-in date.
  - Clear red warning indicators and disabled calculation when inputs are invalid.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **Architecture**: Single-page application using Flutter's native `StatefulWidget` for lightweight reactive state management.
- **Data Source**: Local mock dataset (`lib/data/mock_rooms.dart`).

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
