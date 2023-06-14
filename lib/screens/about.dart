import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developers'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DeveloperCard(
              name: 'Coleen Anne Crisostomo',
              description: 'EXCELLENCE-2',
            ),
            SizedBox(height: 16.0),
            DeveloperCard(
              name: 'Godfrey Angelo Convento',
              description: 'EXCELLENCE-2',
            ),
            SizedBox(height: 16.0, width: 16.0),
            DeveloperCard(
              name: 'Zairra Mille D. Dela Calzada',
              description: 'EXCELLENCE-2',
            ),
            SizedBox(height: 16.0),
            DeveloperCard(
              name: 'JC Mae Peroz',
              description: 'EXCELLENCE-2',
            ),
            SizedBox(height: 16.0),
            DeveloperCard(
              name: 'Justin Jose Ruaya',
              description: 'EXCELLENCE-2',
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String description;

  const DeveloperCard(
      {super.key, required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade800,
      elevation: 4.0,
      //border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0, width: double.infinity),
            Text(
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
                description),
          ],
        ),
      ),
    );
  }
}
