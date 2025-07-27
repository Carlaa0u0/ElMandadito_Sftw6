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
            CategoryButtons(),
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
            const ProductGridHomeSection(), // Aquí se inserta la cuadrícula de productos
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// **ProductGridHomeSection - NO ANIDADA DENTRO DE OTRA CLASE**
class ProductGridHomeSection extends StatefulWidget {
  const ProductGridHomeSection({super.key});

  @override
  State<ProductGridHomeSection> createState() => _ProductGridHomeSectionState();
}

class _ProductGridHomeSectionState extends State<ProductGridHomeSection> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {

      //* esto se puede cambiar

      final List<String> exampleBarcodes = [
        '3017624010701', // Nescafe
        '049635000010',  // Heinz Ketchup
        '7613036894042', // Kit Kat
        '5000159489025', // Coca-Cola
        '8710400030064', // Milka Chocolate
        '3270190013324', // Evian Agua Mineral
        '5449000000996', // Snickers
        '3023290000018', // Danone Yogurt Natural
        '3089300000018', // Lactel Leche (Ejemplo Francia)
        '8480000000011', // Un ejemplo de código de barras genérico de España, para mostrar un caso "no encontrado" si no existe.
      ];

      List<Product> fetchedProducts = [];
      for (String barcode in exampleBarcodes) {

        final ProductQueryConfiguration configuration = ProductQueryConfiguration(
          barcode,
          language: OpenFoodFactsLanguage.SPANISH,
          fields: [
            ProductField.BARCODE,
            ProductField.NAME, 
            ProductField.IMAGE_FRONT_URL, 
            ProductField.BRANDS,
            ProductField.INGREDIENTS_TEXT,
            ProductField.NUTRISCORE, 
            ProductField.NOVA_GROUP, 
            ProductField.COUNTRIES_TAGS, 
            ProductField.CATEGORIES_TAGS, 
            ProductField.ALLERGENS, 
          ],
          version: ProductQueryVersion.v3, 
        );

        final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(configuration);

        if (result.status == 1 && result.product != null) {
          fetchedProducts.add(result.product!);
        }
      }

      setState(() {
        _products = fetchedProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar productos: $e';
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
      return const Center(child: Text('No se encontraron productos para mostrar.'));
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
          final price = 'N/A'; // Open Food Facts API no proporciona precios directamente
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