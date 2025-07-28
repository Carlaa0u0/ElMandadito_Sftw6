// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/image_carousel.dart';
import '../widgets/category_buttons.dart';
import '../widgets/product_card.dart'; // Aunque ProductCard se usa en ProductGridHomeSection
import '../widgets/login_prompt_sheet.dart';
import 'product_detail_screen.dart';

/// Pantalla principal de la aplicación.
/// Muestra un carrusel, botones de categorías y una cuadrícula de productos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Esta función `showLoginPromptSheet` muestra una ventana emergente de inicio de sesión.
  // Importante: Su lugar ideal sería en un servicio o en el archivo principal (`main.dart`).
  void showLoginPromptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: LoginPromptSheet(
                  onLogin: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login_screen');
                  },
                  onRegister: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/register_screen');
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color(0xFFCB3344), // Color de la barra superior.
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'El Mandadito', // Título de la aplicación.
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // Campo de búsqueda en la parte inferior del AppBar.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const ImageCarousel(), // Muestra un carrusel de imágenes.
            const SizedBox(height: 16),
            // Título de la sección de categorías.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CategoryButtons(), // Muestra botones de categorías.
            const SizedBox(height: 16),
            // Título de la sección de productos.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Productos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const ProductGridHomeSection(), // Muestra la cuadrícula de productos.

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Sección de la cuadrícula de productos en la pantalla de inicio.
class ProductGridHomeSection extends StatelessWidget {
  const ProductGridHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // Deshabilita el scroll del grid.
        shrinkWrap: true, // El grid ocupa solo el espacio necesario.
        itemCount: 8, // Muestra 8 productos de ejemplo.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 productos por fila.
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7, // Proporción del tamaño de cada tarjeta.
        ),
        itemBuilder: (context, index) {
          // Datos de ejemplo para cada producto.
          final productName = 'Producto ${index + 1}';
          final imageUrl = 'https://via.placeholder.com/150';
          final price = (10.0 + index * 2).toStringAsFixed(2);
          final description = 'Breve descripción del producto ${index + 1}.';
          return GestureDetector(
            onTap: () {
              // Al tocar un producto, navega a la pantalla de detalles.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ProductDetailScreen(
                    productName: productName,
                    imageUrl: imageUrl,
                    price: price,
                    description: description,
                  ),
                ),
              );
            },
            child: ProductCard( // Muestra la tarjeta del producto.
              productName: productName,
              imageUrl: imageUrl,
              price: price,
            ),
          );
        },
      ),
    );
  }
}