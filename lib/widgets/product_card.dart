import 'package:flutter/material.dart';

/// Tarjeta que muestra un producto individual.
/// Incluye el nombre, una imagen real y el precio.
class ProductCard extends StatelessWidget {
  final String productName; // Nombre del producto.
  final String imageUrl; // URL real de la imagen.
  final String price; // Precio del producto.

  const ProductCard({
    super.key,
    required this.productName,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto desde URL
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://via.placeholder.com/150',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.blue.shade400,
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.white70, size: 40),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Nombre del producto
            Text(
              productName.isNotEmpty ? productName : 'Sin nombre',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Precio del producto
            Text(
              price.isNotEmpty ? '\$$price' : '\$0.00',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
