
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/router.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final appRouter = AppRouter(authService);

    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return MaterialApp.router(
      title: 'Perfumeria Luxury',
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme).copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            textStyle: baseTheme.textTheme.displayLarge,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            textStyle: baseTheme.textTheme.displayMedium,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.playfairDisplay(
            textStyle: baseTheme.textTheme.displaySmall,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            textStyle: baseTheme.textTheme.headlineMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: baseTheme.colorScheme.primaryContainer,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: baseTheme.colorScheme.onPrimaryContainer,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 5,
          shadowColor: baseTheme.colorScheme.shadow.withAlpha(128),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
         floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
        ),
      ),
      routerConfig: appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
