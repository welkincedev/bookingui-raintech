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
    if (_checkInDate != null &&
        _checkOutDate != null &&
        _errorMessage == null) {
      return _stripTime(
        _checkOutDate!,
      ).difference(_stripTime(_checkInDate!)).inDays;
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
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hotel),
            SizedBox(width: 8),
            Text('Grand Horizon Hotel Booking'),
          ],
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth >= 768;

                if (isWideScreen) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Pane: Room Catalog Grid
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Your Room',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.6,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  itemCount: mockRooms.length,
                                  itemBuilder: (context, index) {
                                    return _buildRoomCard(mockRooms[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Right Pane: Date Selection & Summary
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Reservation Details',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                _buildDatePickers(),
                                _buildErrorBanner(),
                                const SizedBox(height: 16),
                                _buildSummaryCard(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Mobile / Compact Layout
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDatePickers(),
                      _buildErrorBanner(),
                      const SizedBox(height: 12),
                      Text(
                        'Available Rooms',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: mockRooms.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildRoomCard(mockRooms[index]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryCard(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _selectCheckInDate(context),
                icon: const Icon(Icons.calendar_today, size: 18),
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
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _selectCheckOutDate(context),
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(
                  _checkOutDate == null
                      ? 'Check-out Date'
                      : _formatDate(_checkOutDate!),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    final error = _errorMessage;
    if (error == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    final isSelected = _selectedRoom?.roomCode == room.roomCode;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRoom = room;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? theme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        color: isSelected
            ? theme.colorScheme.primaryContainer.withAlpha(50)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    room.roomCode,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? theme.primaryColor : Colors.black87,
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected ? theme.primaryColor : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                room.roomType,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Max Guests: ${room.maxGuests}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '₹${room.pricePerNight.toInt()} / night',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final error = _errorMessage;
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: error != null
          ? Colors.red.shade50
          : (_isBookingValid
                ? theme.colorScheme.primaryContainer
                : Colors.grey.shade100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _isBookingValid ? Icons.receipt_long : Icons.info_outline,
                  color: error != null
                      ? Colors.red
                      : (_isBookingValid
                            ? theme.colorScheme.onPrimaryContainer
                            : Colors.grey.shade700),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Booking Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: error != null
                        ? Colors.red
                        : (_isBookingValid
                              ? theme.colorScheme.onPrimaryContainer
                              : Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            if (error != null)
              Text(
                error,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.red,
                ),
              )
            else if (_isBookingValid)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room: ${_selectedRoom!.roomCode} (${_selectedRoom!.roomType})',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: $_numberOfNights night(s)',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking for $_numberOfNights nights. Total: ₹${_totalPrice.toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              )
            else
              Text(
                _selectedRoom == null
                    ? 'Please select a room to calculate total.'
                    : 'Select valid check-in & check-out dates.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
