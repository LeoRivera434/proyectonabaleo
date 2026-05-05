
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/perfume.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';

class PerfumesScreen extends StatelessWidget {
  const PerfumesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      body: StreamBuilder<List<Perfume>>(
        stream: firestoreService.getPerfumes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No perfumes yet. Add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final perfumes = snapshot.data!;

          return ListView.builder(
            itemCount: perfumes.length,
            itemBuilder: (context, index) {
              final perfume = perfumes[index];
              return Card(
                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () => context.go('/perfumes/details', extra: perfume),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(perfume.name, style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 4),
                              Text(perfume.brand, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('Stock: ${perfume.stock}', style: TextStyle(color: perfume.stock > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('\$${perfume.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
                              onPressed: () => context.go('/perfumes/edit', extra: perfume),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Perfume'),
                                    content: const Text('Are you sure you want to delete this perfume?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          firestoreService.deletePerfume(perfume.id!);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/perfumes/add'),
        child: const Icon(Icons.add),
        tooltip: 'Add Perfume',
      ),
    );
  }
}
