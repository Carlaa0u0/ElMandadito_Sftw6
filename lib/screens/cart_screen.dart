import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../services/appwrite_service.dart';

class CartScreen extends StatefulWidget {
  final void Function() onGoHome;
  final String userId;

  const CartScreen({
    super.key,
    required this.onGoHome,
    required this.userId,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<models.Document> carrito = [];

  @override
  void initState() {
    super.initState();
    _cargarCarrito();
  }

  Future<void> _cargarCarrito() async {
    final resultado = await AppwriteService().obtenerCarrito(widget.userId);
    setState(() {
      carrito = resultado;
    });
  }

  Future<void> _eliminarProducto(String id) async {
    await AppwriteService().eliminarDelCarrito(id);
    await _cargarCarrito();
  }

  double _calcularTotal() {
    double total = 0.0;
    for (var item in carrito) {
      final data = item.data;
      final precioRaw = data['precio'];

      double precio = 0.0;
      if (precioRaw is double) {
        precio = precioRaw;
      } else if (precioRaw is int) {
        precio = precioRaw.toDouble();
      } else if (precioRaw is String) {
        precio = double.tryParse(precioRaw) ?? 0.0;
      }

      total += precio; // Suponiendo cantidad fija 1
    }
    return total;
  }

  Future<void> _procederPago(double total) async {
    try {
      final url = Uri.parse(
          'http://localhost:3000/create-checkout-session'); // Cambia si usas URL pública
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (total * 100).toInt(), // Stripe espera centavos
          'currency': 'usd',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['url'];
        if (await canLaunch(checkoutUrl)) {
          await launch(checkoutUrl, forceSafariVC: false, forceWebView: false);

          // Vaciar carrito después de iniciar pago
          await AppwriteService().vaciarCarrito(widget.userId);
          await _cargarCarrito();
        } else {
          throw 'No se pudo abrir Stripe Checkout';
        }
      } else {
        throw 'Error creando sesión: ${response.body}';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar pago: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _calcularTotal();

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
                      icon: const Icon(Icons.arrow_back,
                          size: 30, color: Colors.white),
                      onPressed: widget.onGoHome,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Carrito',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
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
            child: carrito.isEmpty
                ? const Center(child: Text('El carrito está vacío'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final item = carrito[index].data;
                      final precio = item['precio'].toString();

                      return CartItemCard(
                        id: carrito[index].$id,
                        productName: item['nombre'] ?? 'Sin nombre',
                        price: precio,
                        imageUrl: item['imagen'] ?? '',
                        onDelete: _eliminarProducto,
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color(0xFFCB3344),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _procederPago(total),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB3344),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Proceder a pagar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final String id;
  final String productName;
  final String price;
  final String imageUrl;
  final void Function(String) onDelete;

  const CartItemCard({
    super.key,
    required this.id,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final doublePrice = double.tryParse(price) ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              '\$${doublePrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[700]),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400], size: 28),
              onPressed: () => onDelete(id),
            ),
          ],
        ),
      ),
    );
  }
}
