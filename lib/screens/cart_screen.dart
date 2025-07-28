// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';

/// Pantalla del carrito de compras.
/// Muestra los productos y permite volver o ir a pagar.
class CartScreen extends StatelessWidget {
  final void Function() onGoHome; // Función para volver a la página principal.

  const CartScreen({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    // Productos de ejemplo en el carrito.
    final List<Map<String, String>> cartItems = [
      {'name': 'Producto 1', 'quantity': '2', 'price': '15.00'},
      {'name': 'Producto 2', 'quantity': '1', 'price': '22.50'},
      {'name': 'Producto 3', 'quantity': '3', 'price': '8.75'},
      {'name': 'Producto 4', 'quantity': '1', 'price': '30.00'},
    ];

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
                      onPressed: onGoHome, // Volver atrás.
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
          // Lista de los ítems del carrito.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                // Muestra cada producto en una tarjeta.
                return CartItemCard(
                  productName: item['name']!,
                  quantity: item['quantity']!,
                  price: item['price']!,
                );
              },
            ),
          ),
          // Botón para ir a pagar.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Aquí va la lógica de pago.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Procediendo al pago...')),
                );
              },
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

/// Tarjeta para un solo ítem del carrito.
class CartItemCard extends StatelessWidget {
  final String productName;
  final String quantity;
  final String price;

  const CartItemCard({
    super.key,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Espacio para la imagen del producto.
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.image, color: Colors.white70, size: 30),
            ),
            const SizedBox(width: 12),
            // Nombre, cantidad y precio del producto.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'cant. $quantity',
                          style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'precio \$$price',
                          style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón para eliminar el producto.
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400], size: 28),
              onPressed: () {
                // TODO: Aquí va la lógica para eliminar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Producto "${productName}" eliminado.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}