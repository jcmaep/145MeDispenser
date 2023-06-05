// import 'package:flutter/material.dart';

import 'package:app/screens/medicine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});
  String get initialRoute {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return '/';
    }

    return '/profile';
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    final providers = [
      GoogleProvider(
        clientId:
            '658468262790-gup5hldepv1jh1clqurq4q5hp91fbfkn.apps.googleusercontent.com',
      ),
    ];

    return MaterialApp(
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Container(
                alignment: Alignment.center,
                height: 200,
                width: 200,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/logo.png'),
                ),
              );
            },
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
            children: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                child: const Text('Input Medicine Information'),
              ),
            ],
          );
          // return const MyHomePage(title: 'Medicine Information');
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
