import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set debugShowCheckedModeBanner to false
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MeDispenser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController machineIDController = TextEditingController();
  final TextEditingController prescriptionNameController = TextEditingController();
  final TextEditingController intakeIntervalController = TextEditingController();
  final TextEditingController intakeTimesController = TextEditingController();
  bool isChecked = false;

  void _confirmButtonPressed() {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: machineIDController,
              decoration: InputDecoration(
                labelText: 'Machine ID',
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: prescriptionNameController,
              decoration: InputDecoration(
                labelText: 'Prescription Name',
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: intakeIntervalController,
              decoration: InputDecoration(
                labelText: 'Intake Interval',
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: intakeTimesController,
              decoration: InputDecoration(
                labelText: 'Intake Times',
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
              ),
            ),
            SizedBox(height: 16.0),
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
                Flexible(
                  child: Text(
                    'I hereby declare that the information provided in this form is complete, true, and correct to the best of my knowledge',
                    softWrap: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _confirmButtonPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF0068FF)),
                foregroundColor: MaterialStateProperty.all(Colors.white), // Set text color to white
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
