// lib/screens/home_screen.dart
import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:flutter/material.dart';
import '../widgets/image_carousel.dart';
import '../widgets/category_buttons.dart';
import '../widgets/product_card.dart';
import '../widgets/login_prompt_sheet.dart';
import 'product_detail_screen.dart';

/// Pantalla principal de la aplicación.
/// Muestra un carrusel, botones de categorías y una cuadrícula de productos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Esta función `showLoginPromptSheet` muestra una ventana emergente de inicio de sesión.
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
            const ImageCarousel(),
            const SizedBox(height: 16),
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
            CategoryButtons(
              onCategorySelected: (categoryTag) {
                _productGridKey.currentState?.loadProductsByCategory(categoryTag);
              }
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
            ProductGridHomeSection(key: _productGridKey), // Aquí se inserta la cuadrícula de productos
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

final GlobalKey<_ProductGridHomeSectionState> _productGridKey = GlobalKey();



// **ProductGridHomeSection - NO ANIDADA DENTRO DE OTRA CLASE**
// ProductGridHomeSection - Fuera de HomeScreen
class ProductGridHomeSection extends StatefulWidget {
  const ProductGridHomeSection({super.key});

  @override
  State<ProductGridHomeSection> createState() => _ProductGridHomeSectionState();
}

class _ProductGridHomeSectionState extends State<ProductGridHomeSection> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _currentCategoryTag = 'en:food'; // 2. Estado para la categoría actual

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Carga inicial con la categoría por defecto
  }

  // 3. Nuevo método para cargar productos por una categoría específica
  void loadProductsByCategory(String categoryTag) {
    if (_currentCategoryTag == categoryTag) {
      return; // Evita recargar si la categoría no ha cambiado
    }
    setState(() {
      _currentCategoryTag = categoryTag;
    });
    _loadProducts(); // Vuelve a cargar los productos con la nueva categoría
  }


  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _products = []; // Limpia la lista anterior al cargar nuevos productos
    });

    try {
      final ProductSearchQueryConfiguration parameters = ProductSearchQueryConfiguration(
        language: OpenFoodFactsLanguage.SPANISH,
        fields: [
          ProductField.BARCODE,
          ProductField.NAME,
          ProductField.IMAGE_FRONT_URL,
          ProductField.BRANDS,
          ProductField.INGREDIENTS_TEXT,
          ProductField.NOVA_GROUP,
          ProductField.COUNTRIES_TAGS,
          ProductField.CATEGORIES_TAGS,
        ], parametersList: [
          //PageSize(size: 10)
        ],
        version: ProductQueryVersion.v3
      );

      final SearchResult searchResult = await OpenFoodAPIClient.searchProducts(
        null, // O User() si tu configuración requiere un objeto User explícito y no es suficiente con UserAgent global
        parameters,
      );

      if (searchResult.products != null && searchResult.products!.isNotEmpty){
        _products = searchResult.products!
            .where((p) => p.productName != null && p.imageFrontUrl != null)
            .toList();
      } else {
        _errorMessage = 'No se encontraron productos con la búsqueda para $_currentCategoryTag.';
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar productos: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('Error cargando productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text('$_errorMessage\nIntenta de nuevo más tarde.'));
    }

    if (_products.isEmpty) {
      return const Center(child: Text('No se encontraron productos para mostrar (después de filtrar).'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final product = _products[index];
          final productName = product.productName ?? 'Producto sin nombre';
          final imageUrl = product.imageFrontUrl ?? 'https://via.placeholder.com/150';
          final price = 'N/A';
          final description = product.ingredientsText ?? 'Ingredientes no disponibles.';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ProductDetailScreen(
                    productName: productName,
                    imageUrl: imageUrl,
                    price: price,
                    description: description,
                    product: product,
                  ),
                ),
              );
            },
            child: ProductCard(
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