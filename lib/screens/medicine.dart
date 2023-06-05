import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController machineIDController = TextEditingController();
  final TextEditingController prescriptionNameController =
      TextEditingController();
  final TextEditingController intakeIntervalController =
      TextEditingController();
  final TextEditingController intakeTimesController = TextEditingController();
  bool isChecked = false;

  void _confirmButtonPressed() {
    final machineID = machineIDController.text;
    final prescriptionName = prescriptionNameController.text;
    final intakeInterval = intakeIntervalController.text;
    final intakeTimes = intakeTimesController.text;

    // Store the data in Firebase
    FirebaseFirestore.instance.collection('collection-name').add({
      'machineID': machineID,
      'prescriptionName': prescriptionName,
      'intakeInterval': intakeInterval,
      'intakeTimes': intakeTimes,
    });

    setState(() {
      machineIDController.clear();
      prescriptionNameController.clear();
      intakeIntervalController.clear();
      intakeTimesController.clear();
      isChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Medicine Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: machineIDController,
                decoration: const InputDecoration(
                  labelText: 'Machine ID',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: prescriptionNameController,
                decoration: const InputDecoration(
                  labelText: 'Prescription Name',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: intakeIntervalController,
                decoration: const InputDecoration(
                  labelText: 'Intake Interval',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: intakeTimesController,
                decoration: const InputDecoration(
                  labelText: 'Intake Times',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xFF0068FF),
                    ),
                  ),
                  const Flexible(
                    child: Text(
                      'I hereby declare that the information provided in this form is complete, true, and correct to the best of my knowledge',
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _confirmButtonPressed,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF0068FF)),
                  foregroundColor: MaterialStateProperty.all(
                      Colors.white), // Set text color to white
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
