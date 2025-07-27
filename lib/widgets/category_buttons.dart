// lib/widgets/category_buttons.dart
import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {

  final void Function(String category) onCategorySelected;

  const CategoryButtons ({
    super.key,
    required this.onCategorySelected,
  });


  // La lista 'categories' puede ser final, pero no necesariamente const si la vamos a modificar
  // o si sus elementos no son todos constantes. Para este caso, está bien como final.
  final List<String> categories = const [ // <-- OPCIONAL: Puedes hacer la lista 'const' si todos sus elementos son literales.
    "Frutas", "Verduras", "Carnes", "Lácteos", "Bebidas", "Snacks",
    "Panadería", "Congelados", "Despensa", "Limpieza", "Higiene Personal", "Mascotas"
  ];

  String _getOffCategoryTag(String friendlyCategory) {
    switch(friendlyCategory) {
      case "Frutas": return "en:fruits";
      case "Verduras": return "en:plant-based-foods"; // O "en:vegetables" si hay una más específica
      case "Carnes": return "en:meats";
      case "Lácteos": return "en:dairies";
      case "Bebidas": return "en:beverages";
      case "Snacks": return "en:snacks";
      case "Panadería": return "en:bakery-products";
      case "Congelados": return "en:frozen-foods";
      case "Despensa": return "en:groceries"; 
      case "Limpieza": return "en:household-products"; 
      case "Higiene Personal": return "en:personal-care-products"; 
      case "Mascotas": return "en:pet-foods"; 
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final String categoryName = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0), // Espacio entre botones
            child: ElevatedButton(
              onPressed: () {
                final offCategoryTag = _getOffCategoryTag(categoryName);
                if (offCategoryTag.isNotEmpty) {
                  onCategorySelected(offCategoryTag);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cargando productos de: $categoryName')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Categoría no mapeada: $categoryName')),
                  );
                }
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