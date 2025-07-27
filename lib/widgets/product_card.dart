import 'package:flutter/material.dart';
/// Tarjeta que muestra un producto individual.
/// Incluye el nombre, una imagen de ejemplo y el precio.
class ProductCard extends StatelessWidget {
  final String productName; // Nombre del producto.
  final String imageUrl;    // URL de la imagen (usada como identificador, no para cargar imagen real).
  final String price;       // Precio del producto.

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
            // Contenedor para la imagen del producto (es un placeholder azul).
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                      )
                    );
                  },
                )
              )
            ),
            const SizedBox(height: 10),
            // Nombre del producto.
            Text(
              productName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1, // Limita a una línea.
              overflow: TextOverflow.ellipsis, // Añade "..." si el texto es muy largo.
            ),
            const SizedBox(height: 4),
            // Texto que combina "Desc. y precio" con el precio real.
            Text(
              'Desc. y precio \$$price',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 2, // Limita a dos líneas.
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}