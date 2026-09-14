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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _checkInDate == null
                          ? 'Check-in Date'
                          : '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      _checkOutDate == null
                          ? 'Check-out Date'
                          : '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Booking Summary:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Select dates & room',
                      style: TextStyle(color: Colors.grey.shade600),
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
