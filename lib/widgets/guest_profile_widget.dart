import 'package:flutter/material.dart';
import '../models/guest.dart';

class GuestProfileWidget extends StatefulWidget {
  final Guest guest;
  GuestProfileWidget({required this.guest});

  @override
  _GuestProfileWidgetState createState() => _GuestProfileWidgetState();

}


class _GuestProfileWidgetState extends State<GuestProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final guestSatisfied = widget.guest.isSatisfied; // Access the guest from the widget

    return Opacity(
      opacity: guestSatisfied ? 0 : 1,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.asset(widget.guest.iconUrl, height: 40), // Use widget.guest.iconUrl here
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.guest.name, style: TextStyle(fontWeight: FontWeight.bold)), // Use widget.guest.name here
                  Text('Prefers:'),
                  Wrap(
                    children: widget.guest.preferences.map((preference) => // Use widget.guest.preferences here
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Chip(label: Text(preference)),
                      ),
                    ).toList(),
                  ),
                  SizedBox(height: 8),
                  Text('Dietary Restrictions:'),
                  Wrap(
                    children: widget.guest.dietaryRestrictions.map((restriction) => // Use widget.guest.dietaryRestrictions here
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Chip(label: Text(restriction)),
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Example method to update the guest's satisfaction status
  void updateGuestSatisfaction(bool isSatisfied) {
    setState(() {
      widget.guest.isSatisfied = isSatisfied;
    });
  }
}