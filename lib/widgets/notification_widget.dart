import 'package:flutter/material.dart';
import 'package:food_waste_game/models/unlock-notification.dart';


class UnlockNotificationWidget extends StatefulWidget {
  final UnlockNotification notification;

  const UnlockNotificationWidget({Key? key, required this.notification}) : super(key: key);

  @override
  _UnlockNotificationWidgetState createState() => _UnlockNotificationWidgetState();
}

class _UnlockNotificationWidgetState extends State<UnlockNotificationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
void initState() {
  super.initState();
  _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
  _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  _controller.forward().then((value) {
    Future.delayed(Duration(seconds: 2), () {
      // Check if the widget is still mounted before reversing the animation or popping the navigator
      if (mounted) {
        _controller.reverse().then((value) {
          // Ensure mounted before calling Navigator.pop to avoid building during tree mutation.
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity:  _opacityAnimation, 
      child: AlertDialog( // No more FadeTransition
        title: Center(child: Text(widget.notification.title, textAlign: TextAlign.center)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              // Icon(widget.notification.icon, size: 48.0), // Add your icon here
              Image.asset(widget.notification.iconPath, height: 300.0),
              Text(widget.notification.description, textAlign: TextAlign.center),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
