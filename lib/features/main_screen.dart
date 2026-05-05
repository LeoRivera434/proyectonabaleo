
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/perfumes/screens/perfumes_screen.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Placeholder for a logo
            Image.asset(
              'assets/images/logo.png', // Make sure to add a logo in this path
              height: 40,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.bubble_chart),
            ),
            const SizedBox(width: 10),
            const Text('Perfumeria Luxury'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              // GoRouter will automatically redirect to the login screen
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const PerfumesScreen(),
    );
  }
}
