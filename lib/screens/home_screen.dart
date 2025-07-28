// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';
import '../widgets/image_carousel.dart';
import '../widgets/category_buttons.dart';
import '../widgets/product_card.dart';
import '../widgets/login_prompt_sheet.dart';
import 'product_detail_screen.dart';
import 'package:appwrite/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppwriteService appwriteService = AppwriteService();
  late Future<List<Document>> productosFuture;
  String categoriaSeleccionada = '';

  @override
  void initState() {
    super.initState();
    productosFuture = appwriteService.fetchProductos(); // carga todos
  }

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

  void filtrarPorCategoria(String categoria) {
    setState(() {
      if (categoriaSeleccionada.toLowerCase() == categoria.toLowerCase()) {
        categoriaSeleccionada = '';
        productosFuture = appwriteService.fetchProductos(); // sin filtro
      } else {
        categoriaSeleccionada = categoria;
        productosFuture = appwriteService.fetchProductos(categoria: categoria);
      }
    });
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
        backgroundColor: const Color(0xFFCB3344),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'El Mandadito',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
            const ImageCarousel(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: categoriaSeleccionada.isEmpty
                      ? Colors.black
                      : const Color(0xFFCB3344),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CategoryButtons(
              onCategorySelected: filtrarPorCategoria,
              selectedCategory: categoriaSeleccionada,
            ),
            const SizedBox(height: 16),
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
            FutureBuilder<List<Document>>(
              future: productosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error al cargar productos: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No hay productos disponibles.'),
                  );
                } else {
                  final productos = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        final productName =
                            producto.data['nombre'] ?? 'Sin nombre';
                        final imageUrl = producto.data['imagen'] ??
                            'https://via.placeholder.com/150';
                        final dynamic precioRaw =
                            producto.data['precio'] ?? 0.0;
                        final double price = precioRaw is double
                            ? precioRaw
                            : (precioRaw is int
                                ? precioRaw.toDouble()
                                : double.tryParse(precioRaw.toString()) ?? 0.0);
                        final description = producto.data['descripcion'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => ProductDetailScreen(
                                  productId: producto.$id, // id real
                                  productName: productName,
                                  imageUrl: imageUrl,
                                  price: price,
                                  description: description,
                                ),
                              ),
                            );
                          },
                          child: ProductCard(
                            productName: productName,
                            imageUrl: imageUrl,
                            price: price.toStringAsFixed(2),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
