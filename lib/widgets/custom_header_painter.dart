import 'package:flutter/material.dart';

class CustomHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Paint paint = Paint()..color = Colors.red.shade700; // Un rojo fuerte similar al de la imagen

    // Dibujar la forma ondulada en la parte inferior del encabezado
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.6, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    // Dibujar los signos de más (cruces)
    final Paint plusPaint = Paint()
      ..color = Colors.white.withOpacity(0.3) // Blanco ligeramente transparente para el efecto
      ..strokeWidth = 3.0 // Grosor de la línea
      ..style = PaintingStyle.stroke; // Solo el contorno

    const double plusSize = 15; // Tamaño de cada signo de más
    const double spacing = 40; // Espaciado entre los signos de más

    // Iterar para dibujar múltiples signos de más
    for (double x = 20; x < size.width; x += spacing) {
      for (double y = 20; y < size.height * 0.7; y += spacing) { // Limitar a la zona roja
        // Línea horizontal del más
        canvas.drawLine(Offset(x - plusSize / 2, y), Offset(x + plusSize / 2, y), plusPaint);
        // Línea vertical del más
        canvas.drawLine(Offset(x, y - plusSize / 2), Offset(x, y + plusSize / 2), plusPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No es necesario repintar si no cambian las propiedades
  }
}