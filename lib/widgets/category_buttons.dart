import 'package:flutter/material.dart';

class CategoryButtons extends StatefulWidget {
  const CategoryButtons({super.key});

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  bool showAll = false;

  final List<String> categories = [
    "Frutas", "Verduras", "Carnes", "Lácteos", "Bebidas", "Snacks"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: categories.map((cat) {
            return ElevatedButton(
              onPressed: () {},
              child: Text(cat),
            );
          }).toList(),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              showAll = !showAll;
            });
          },
          child: Text(showAll ? 'Ocultar' : 'Ver más'),
        ),
        if (showAll)
          Column(
            children: [
              const Text("Todos los productos disponibles:"),
              ...List.generate(10, (index) => Text('Producto ${index + 1}')),
            ],
          )
      ],
    );
  }
}
