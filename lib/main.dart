import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:luxe_loft/Screens/Splash.dart';
import 'package:luxe_loft/firebase_options.dart';
import 'package:luxe_loft/Screens/otp_screen.dart';
import 'package:luxe_loft/screens/home_screen.dart';
import 'package:luxe_loft/screens/login_screen.dart';
import 'package:luxe_loft/screens/onboarding_screen.dart';
import 'package:luxe_loft/screens/signup_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duka App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF15919B), // teal from Figma
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/otp': (context) => const OtpScreen(),
      },
    );
  }
}
