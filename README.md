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

