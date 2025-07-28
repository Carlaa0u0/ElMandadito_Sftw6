// lib/widgets/category_buttons.dart

import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  final Function(String) onCategorySelected;
  final String selectedCategory;

  CategoryButtons({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  final List<String> categories = const [
    "Frutas",
    "Verduras",
    "Carnes",
    "Lácteos",
    "Bebidas",
    "Snacks",
    "Panadería",
    "Congelados",
    "Despensa",
    "Limpieza",
    "Higiene Personal",
    "Mascotas"
  ];

  String normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n');
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
          final categoria = categories[index];
          final isSelected =
              normalizar(categoria) == normalizar(selectedCategory);

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () => onCategorySelected(categoria),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? const Color(0xFFCB3344) : Colors.grey[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(categoria),
            ),
          );
        },
      ),
    );
  }
}
