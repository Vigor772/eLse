import 'package:else_revamp/screens/cpr.dart';
import 'package:else_revamp/screens/faq.dart';
import 'package:else_revamp/screens/guideline.dart';
import 'package:else_revamp/screens/home.dart';
import 'package:else_revamp/screens/how-it-works.dart';
import 'package:else_revamp/screens/loading-screen.dart';
import 'package:else_revamp/screens/login.dart';
import 'package:else_revamp/screens/profile.dart';
import 'package:else_revamp/screens/update.dart';
import 'package:else_revamp/screens/pulse.dart';
import 'package:else_revamp/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserSession(),
      getPages: [
        GetPage(name: '/', page: () => LogIn()),
        GetPage(name: '/signup', page: () => SignUp()),
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/profile', page: () => Profile()),
        GetPage(name: '/update', page: () => Update('')),
        GetPage(name: '/pulse', page: () => Pulse()),
        GetPage(name: '/cpr', page: () => Cpr()),
        GetPage(name: '/faq', page: () => FAQ()),
        GetPage(name: '/how-it-works', page: () => HowTo()),
        GetPage(name: '/guide', page: () => Guidelines()),
      ],
    );
  }
}

//Checks whenever a user signed-in or signed-out
//Shows specific Home screen if user already signed-in
//Shows Loading screen transition to login if there is no user
class UserSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const LoadingScreen(navigate: Home());
        }
        return const LoadingScreen(navigate: LogIn());
      },
    );
  }
}
