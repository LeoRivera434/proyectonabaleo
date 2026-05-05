
import 'package:flutter/material.dart';
import 'package:myapp/models/perfume.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PerfumeEditScreen extends StatefulWidget {
  final Perfume? perfume;

  const PerfumeEditScreen({super.key, this.perfume});

  @override
  State<PerfumeEditScreen> createState() => _PerfumeEditScreenState();
}

class _PerfumeEditScreenState extends State<PerfumeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.perfume?.name);
    _brandController = TextEditingController(text: widget.perfume?.brand);
    _descriptionController = TextEditingController(text: widget.perfume?.description);
    _priceController = TextEditingController(text: widget.perfume?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.perfume?.stock.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      final newPerfume = Perfume(
        id: widget.perfume?.id,
        name: _nameController.text,
        brand: _brandController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text) ?? 0,
      );

      if (widget.perfume == null) {
        // Add new perfume
        firestoreService.addPerfume(newPerfume);
      } else {
        // Update existing perfume
        firestoreService.updatePerfume(newPerfume);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfume == null ? 'Add Perfume' : 'Edit Perfume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Save',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a brand' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                 validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder(), prefixText: '\$'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter the stock quantity';
                   if (int.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
               const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.perfume == null ? 'Add Perfume' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
