import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/notification_helper.dart';

class TestNotificationScreen extends StatelessWidget {
  TestNotificationScreen({Key? key}) : super(key: key);

  final int _delaySeconds = 5;

  void _sendTestNotification(BuildContext context) async {
    final now = DateTime.now().add(Duration(seconds: _delaySeconds));
    try {
      await NotificationHelper.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Test Notification',
        body: 'This is a test notification from PlantPal!',
        scheduledDate: now,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Test notification scheduled for $_delaySeconds seconds from now!',
          ),
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Permission Needed'),
                content: Text(
                  'Exact alarms are not permitted. Please enable "Schedule exact alarms" in your device settings for PlantPal.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule notification: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Notification')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Click the button below to send a test notification.'),
            ElevatedButton(
              onPressed: () => _sendTestNotification(context),
              child: Text('Send Test Notification'),
            ),
            SizedBox(height: 16),
            Text(
              'Tip: Minimize or lock your phone after pressing the button to see the notification.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
