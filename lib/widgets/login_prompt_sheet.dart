import 'package:flutter/material.dart';
import 'package:flutter_proyecto_1/screens/login_screen.dart';
import 'package:flutter_proyecto_1/screens/register_screen.dart';

/// Muestra una ventana emergente para que el usuario inicie sesión o se registre.
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
              // Contenido de la ventana: botones de inicio de sesión y registro.
              child: LoginPromptSheet(
                onLogin: () {
                  Navigator.of(context).pop(); // Cierra el modal.
                  // Importante: Navega a la pantalla de inicio de sesión.
                  Navigator.of(context).pushNamed('/login_screen');
                },
                onRegister: () {
                  Navigator.of(context).pop(); // Cierra el modal.
                  // Importante: Navega a la pantalla de registro.
                  Navigator.of(context).pushNamed('/register_screen');
                },
              ),
            ),
          );
        },
      );
    },
  );
}

/// Widget que contiene los botones para iniciar sesión y registrarse.
class LoginPromptSheet extends StatelessWidget {
  final VoidCallback onLogin;    // Función al presionar "Iniciar sesión".
  final VoidCallback onRegister; // Función al presionar "Registrarse".

  const LoginPromptSheet({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
        bottom: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de arrastre del modal.
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          // Texto principal del aviso.
          const Text(
            'Para continuar con tus compras, debes:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Fila con los botones de "Iniciar sesión" y "Registrarse".
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AuthButton(
                icon: Icons.login,
                label: 'Iniciar sesión',
                onTap: onLogin,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'O', // Separador entre los botones.
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              _AuthButton(
                icon: Icons.person_add,
                label: 'Registrarse',
                onTap: onRegister,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Mensaje motivacional.
          const Text(
            '¡Qué esperas para ser El Mandadito ya!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Widget de botón con ícono y texto.
class _AuthButton extends StatelessWidget {
  final IconData icon;       // Ícono a mostrar.
  final String label;        // Texto del botón.
  final void Function() onTap; // Acción al tocar el botón.

  const _AuthButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contenedor redondo para el ícono.
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.red,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), // Texto debajo del ícono.
      ],
    );
  }
}