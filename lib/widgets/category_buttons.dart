// lib/widgets/category_buttons.dart
import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  // Eliminamos 'const' del constructor porque la lista 'categories' no es const
  CategoryButtons({super.key}); // <-- CORRECCIÓN AQUÍ: SE REMOVIÓ 'const'

  // La lista 'categories' puede ser final, pero no necesariamente const si la vamos a modificar
  // o si sus elementos no son todos constantes. Para este caso, está bien como final.
  final List<String> categories = const [ // <-- OPCIONAL: Puedes hacer la lista 'const' si todos sus elementos son literales.
    "Frutas", "Verduras", "Carnes", "Lácteos", "Bebidas", "Snacks",
    "Panadería", "Congelados", "Despensa", "Limpieza", "Higiene Personal", "Mascotas"
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0), // Espacio entre botones
            child: ElevatedButton(
              onPressed: () {
                // TODO: Lógica para filtrar productos por categoría (este es un TODO, no un error de código)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Categoría seleccionada: ${categories[index]}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB3344), // Color de los botones
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordes más redondeados
                ),
                elevation: 3,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(categories[index]),
            ),
          );
        },
      ),
    );
  }
}