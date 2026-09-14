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

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime initial = _checkInDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime initial = _checkOutDate ??
        (_checkInDate != null
            ? _checkInDate!.add(const Duration(days: 1))
            : DateTime.now());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  int get _numberOfNights {
    if (_checkInDate != null && _checkOutDate != null) {
      return _checkOutDate!.difference(_checkInDate!).inDays;
    }
    return 0;
  }

  bool get _isBookingValid {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _selectedRoom != null &&
        _checkOutDate!.isAfter(_checkInDate!);
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

            // Bottom: Dynamic Booking Summary Card
            Card(
              elevation: 3,
              color: _isBookingValid
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.grey.shade100,
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
                    Text(
                      _isBookingValid
                          ? 'Booking for $_numberOfNights nights. Total: ₹${_totalPrice.toInt()}'
                          : 'Select check-in, check-out & room to calculate total.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _isBookingValid
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Colors.black87,
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
