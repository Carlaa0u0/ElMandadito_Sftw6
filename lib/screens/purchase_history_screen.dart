// lib/screens/purchase_history_screen.dart
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para el historial de compras
    final List<Map<String, String>> purchaseHistoryItems = [
      {'name': 'Producto A', 'quantity': '1', 'price': '25.00', 'date': '2023-01-10'},
      {'name': 'Producto B', 'quantity': '2', 'price': '12.50', 'date': '2023-01-05'},
      {'name': 'Producto C', 'quantity': '1', 'price': '50.00', 'date': '2022-12-28'},
      {'name': 'Producto D', 'quantity': '4', 'price': '5.99', 'date': '2022-12-15'},
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Historial de Compras',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: purchaseHistoryItems.length,
        itemBuilder: (context, index) {
          final item = purchaseHistoryItems[index];
          return PurchaseHistoryItemCard(
            productName: item['name']!,
            quantity: item['quantity']!,
            price: item['price']!,
            purchaseDate: item['date']!,
          );
        },
      ),
    );
  }
}

// Widget auxiliar para los ítems del historial de compras (similar al de carrito)
class PurchaseHistoryItemCard extends StatelessWidget {
  final String productName;
  final String quantity;
  final String price;
  final String purchaseDate;

  const PurchaseHistoryItemCard({
    super.key,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.purchaseDate,
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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade300, // Color azul para placeholder de imagen
                borderRadius: BorderRadius.circular(10),
              ),
              // Aquí iría la imagen del producto real
              child: const Icon(Icons.image, color: Colors.white70, size: 30),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 4),
                  Text(
                    'Fecha: $purchaseDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // No hay botón de eliminar en el historial de compras, pero se podría añadir si fuera necesario
          ],
        ),
      ),
    );
  }
}