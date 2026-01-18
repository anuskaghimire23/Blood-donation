import 'package:flutter/material.dart';

class CenterPage extends StatelessWidget {
  const CenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Blood Centers"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(
          5,
          (index) => Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red),
              title: const Text("Red Cross Center"),
              subtitle: const Text("Lainchaur, Kathmandu\nOpen: 9 AM - 5 PM"),
              trailing: Icon(Icons.directions, color: Colors.blue),
              onTap: () {
                // Implement map/direction feature
              },
            ),
          ),
        ),
      ),
    );
  }
}
