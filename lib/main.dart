import 'package:flutter/material.dart';
import 'package:newsapp/UI/login_view.dart';
import 'package:newsapp/UI/home_view.dart';
import 'package:newsapp/UI/signup_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:newsapp/providers/news_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Handle error if .env file is not found
    debugPrint('Error loading .env file: $e');
  }
  await Supabase.initialize(
    url: 'https://nuyfgodfatozslwnfnjz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51eWZnb2RmYXRvenNsd25mbmp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTczNTUxNjUsImV4cCI6MjA3MjkzMTE2NX0.vdaBQvjtSHTIrI831taarin6ia8CEU2JXkSvreIXXjU',
  );

  // Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NewsProvider())],
      child: MaterialApp(
        initialRoute: isLoggedIn ? '/home' : '/',
        routes: {
          '/': (context) => const LoginView(),
          '/home': (context) => const HomeView(),
          '/signup': (context) => const SignupView(),
        },
      ),
    );
  }
}
