import 'package:flutter/material.dart';

/// Pantalla del Centro de Ayuda.
/// Permite a los usuarios escribir y enviar sus consultas.
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  // Controlador para el campo de texto de la consulta.
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    // Importante: Libera los recursos del controlador cuando la pantalla se cierra.
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        // Vuelve a la pantalla anterior.
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Feedback',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade400, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Si tienes una sugerencia, no dudes en hacérnoslo llegar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Campo de texto para que el usuario escriba su consulta.
            TextField(
              controller: _queryController,
              maxLines: 8, // Permite varias líneas de texto.
              decoration: InputDecoration(
                hintText: 'Escribe tu sugerencia aquí...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              // Botón para enviar la consulta.
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Aquí va la lógica para enviar la consulta (ej. a una API o base de datos).
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sugerencia enviada. Gracias por tu apoyo!')),
                  );
                  _queryController.clear(); // Limpia el campo después de enviar.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCB3344),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Enviar Sugerencia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}