import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:fourth_project/screens/chat_screen.dart';
import 'package:fourth_project/screens/registration_screen.dart';
import 'package:fourth_project/screens/login_screen.dart';
import 'package:fourth_project/screens/welcome_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBTV6WP3c2s0ppsR3uhjS_L58RZ1r8dGX8',
        appId: '1:58497452663:android:3adf1dc4c6450fa9ead472',
        messagingSenderId: '58497452663',
        projectId: 'fourth-project-f06d9',
  ),);

  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
      },
      home: const WelcomeScreen(),
    );
  }
}

