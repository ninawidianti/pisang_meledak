import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String name;
  final String email;

  // ignore: use_super_parameters
  const SettingsPage({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool salesNotifications = true;
  bool newArrivalsNotifications = false;
  bool statusDeliveryNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: widget.name,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: widget.email,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const TextField(
              readOnly: true,
              obscureText: true,
              decoration:  InputDecoration(
                labelText: '************',
                suffixText: 'Change',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Sales'),
              value: salesNotifications,
              onChanged: (bool value) {
                setState(() {
                  salesNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('New arrivals'),
              value: newArrivalsNotifications,
              onChanged: (bool value) {
                setState(() {
                  newArrivalsNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Status Delivery'),
              value: statusDeliveryNotifications,
              onChanged: (bool value) {
                setState(() {
                  statusDeliveryNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
