import 'package:flutter/material.dart';
import '../data/mock_rooms.dart';
import '../models/room.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Room? _selectedRoom;

  DateTime get _today => _stripTime(DateTime.now());

  DateTime _stripTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime initial = _checkInDate ?? _today;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(_today) ? _today : initial,
      firstDate: _today,
      lastDate: _today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        // Reset check-out if it's no longer after check-in
        if (_checkOutDate != null &&
            !_stripTime(_checkOutDate!).isAfter(_stripTime(picked))) {
          _checkOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime minCheckOut = _checkInDate != null
        ? _stripTime(_checkInDate!).add(const Duration(days: 1))
        : _today.add(const Duration(days: 1));

    final DateTime initial = _checkOutDate ?? minCheckOut;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(minCheckOut) ? minCheckOut : initial,
      firstDate: minCheckOut,
      lastDate: _today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  String? get _errorMessage {
    if (_checkInDate != null) {
      final checkIn = _stripTime(_checkInDate!);
      if (checkIn.isBefore(_today)) {
        return 'Check-in date cannot be in the past.';
      }
    }

    if (_checkInDate != null && _checkOutDate != null) {
      final checkIn = _stripTime(_checkInDate!);
      final checkOut = _stripTime(_checkOutDate!);
      if (!checkOut.isAfter(checkIn)) {
        return 'Check-out must be after check-in.';
      }
    }

    return null;
  }

  int get _numberOfNights {
    if (_checkInDate != null && _checkOutDate != null && _errorMessage == null) {
      return _stripTime(_checkOutDate!).difference(_stripTime(_checkInDate!)).inDays;
    }
    return 0;
  }

  bool get _isBookingValid {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _selectedRoom != null &&
        _errorMessage == null;
  }

  double get _totalPrice {
    if (_isBookingValid) {
      return _numberOfNights * _selectedRoom!.pricePerNight;
    }
    return 0.0;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final error = _errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Room Booking'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top: Date Pickers Side-by-Side
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectCheckInDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _checkInDate == null
                          ? 'Check-in Date'
                          : _formatDate(_checkInDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectCheckOutDate(context),
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      _checkOutDate == null
                          ? 'Check-out Date'
                          : _formatDate(_checkOutDate!),
                    ),
                  ),
                ),
              ],
            ),

            // Red Error Banner (Validation Feedback)
            if (error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Middle: Room List with Selection Visual State
            Expanded(
              child: ListView.builder(
                itemCount: mockRooms.length,
                itemBuilder: (context, index) {
                  final room = mockRooms[index];
                  final isSelected = _selectedRoom?.roomCode == room.roomCode;

                  return Card(
                    elevation: isSelected ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    color: isSelected
                        ? Theme.of(context).primaryColor.withAlpha(20)
                        : null,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        '${room.roomCode} - ${room.roomType}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Max Guests: ${room.maxGuests}'),
                      trailing: Text(
                        '₹${room.pricePerNight.toInt()} / night',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedRoom = room;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom: Dynamic Summary & Validation Feedback Card
            Card(
              elevation: 3,
              color: error != null
                  ? Colors.red.shade50
                  : (_isBookingValid
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.grey.shade100),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (error != null)
                      Text(
                        error,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      )
                    else if (_isBookingValid)
                      Text(
                        'Booking for $_numberOfNights nights. Total: ₹${_totalPrice.toInt()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      )
                    else
                      Text(
                        _selectedRoom == null
                            ? 'Please select a room to proceed.'
                            : 'Select valid check-in & check-out dates.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
