
import 'package:flutter/material.dart';
import 'package:myapp/models/perfume.dart';

class PerfumeDetailsScreen extends StatelessWidget {
  final Perfume perfume;

  const PerfumeDetailsScreen({super.key, required this.perfume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(perfume.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brand: ${perfume.brand}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Price: \$${perfume.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Stock: ${perfume.stock}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
