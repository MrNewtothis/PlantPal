import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PlantPal Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to PlantPal!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.list),
              label: Text('View My Plants'),
              onPressed: () {
                Navigator.pushNamed(context, '/plants');
              },
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add a Plant'),
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.notifications),
              label: Text('Test Notification'),
              onPressed: () {
                Navigator.pushNamed(context, '/test-notification');
              },
            ),
          ],
        ),
      ),
    );
  }
}
