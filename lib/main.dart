import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'utils/index.dart';
import 'dart:ui';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'HealthSteady',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => const LoginPage(),
        '/login' : (context) => const LoginPage(),
        '/signUp' : (context) => const SignUpPage(),
        '/myhome' : (context) => MyHomePage(),
        '/home' : (context) =>  HomePage(onButtonPressed: () {
          Navigator.pushNamed(context, '/rank');
        },),
        '/invite' :(context) => const InvitePage(),
        '/workout' : (context) => const WorkoutPage(),
        // '/result' : (context) => const ResultPage(),
        '/setting' : (context) => const SettingPage(),
        '/weekGoal' : (context) => const WeekGoalPage(),
        '/editProfile' : (context) => const EditProfilePage(),

      }
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}
