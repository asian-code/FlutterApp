import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/app/home_screen.dart';
import 'screens/login/create_account_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HashStudios App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4FC3F7),
          secondary: Colors.teal,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(isEmployee: false),
        '/employee': (context) => const LoginScreen(isEmployee: true),
        '/create-account': (context) => const CreateAccountScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}