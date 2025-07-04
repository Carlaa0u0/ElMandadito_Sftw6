import 'package:flutter/material.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/product${index + 1}.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text('Producto ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text('\$10.00', style: TextStyle(color: Colors.green)),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
