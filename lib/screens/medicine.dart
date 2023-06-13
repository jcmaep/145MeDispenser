// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

class MedicineInput extends StatefulWidget {
  const MedicineInput({super.key});

  @override
  State<MedicineInput> createState() => _MedicineInputState();
}

class _MedicineInputState extends State<MedicineInput> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController machineIDController = TextEditingController();
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController intakeIntervalController =
      TextEditingController();
  final TextEditingController intakeTimesController = TextEditingController();
  bool isChecked = false;

  TimeOfDay? selectedTime;

  void _confirmButtonPressed() {
    if (isChecked == true) {
      final patientName = patientNameController.text;
      final machineID = machineIDController.text;
      final medicineName = medicineNameController.text;
      final startTime = startTimeController.text;
      final intakeInterval = intakeIntervalController.text;
      final intakeTimes = intakeTimesController.text;

      // Store the data in Firebase
      FirebaseFirestore.instance.collection('medicine-prescription').add({
        'patientName': patientName,
        'machineID': machineID,
        'medicineName': medicineName,
        'startTime': startTime,
        'intakeInterval': intakeInterval,
        'intakeTimes': intakeTimes,
      });

      setState(() {
        patientNameController.clear();
        machineIDController.clear();
        medicineNameController.clear();
        startTimeController.clear();
        intakeIntervalController.clear();
        intakeTimesController.clear();
        isChecked = false;
      });
    }
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
                controller: patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: machineIDController,
                decoration: const InputDecoration(
                  labelText: 'Machine ID',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: false,
                            ),
                            child: child!,
                          ),
                        ),
                      );
                    },
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                      startTimeController.text = time.format(context);
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: intakeIntervalController,
                decoration: const InputDecoration(
                  labelText: 'Intake Interval',
                  filled: true,
                  fillColor: Color(0xFFD9D9D9),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
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
