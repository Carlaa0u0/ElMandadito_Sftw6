// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final String price;
  final String description; // Nueva propiedad para la descripción
  final Product? product;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.description = 'Descripción detallada del producto. Aquí puedes añadir más información sobre sus características, ingredientes, usos, etc. Este texto es un placeholder para mostrar cómo se vería una descripción más larga.', // Descripción por defecto
    this.product,
  });

  @override
  Widget build(BuildContext context) {

    final String productBrands = product?.brands ?? 'No Disponible';
    final String nutriscore = product?.nutriscore ?? 'No Disponible';
    final String novaGroup = product?.novaGroup.toString() ?? 'No Disponible';
    final String countries = product?.countries ?? 'No Disponibles';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            backgroundColor: const Color(0xFFCB3344),
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Vuelve a la pantalla anterior
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      productName, // El título del AppBar será el nombre del producto
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.ellipsis, // Para manejar textos largos
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del producto
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nombre del producto
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Descripción del producto
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Línea divisoria
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  
                  if (product != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text (
                          'Información Adicional: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 10),
                          _buildDetailRow('Marca:', productBrands),
                          _buildDetailRow('Nutri-Score:', nutriscore.toUpperCase()),
                          _buildDetailRow('Grupo NOVA:', novaGroup),
                          _buildDetailRow('País(es) de Venta:', countries),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Sección de Precio y Botón "Añadir al Carrito" (Sticky footer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3), // Sombra hacia arriba
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Precio',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCB3344), // Color de acento
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Lógica para añadir al carrito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('"${productName}" añadido al carrito!')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: const Text(
                    'Añadir al Carrito',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCB3344), // Color de acento
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            )
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value, 
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            )
          )
        ],
      )
    );
  }
}