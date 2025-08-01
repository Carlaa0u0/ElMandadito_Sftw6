// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'personal_info_screen.dart';
import 'help_center_screen.dart';
import 'purchase_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  final void Function() onGoHome;
  final bool isLoggedIn;
  final String? userName;
  final void Function() onLogout;

  const ProfileScreen({
    super.key,
    required this.onGoHome,
    required this.isLoggedIn,
    this.userName,
    required this.onLogout,
  });

  // Widget auxiliar para los elementos del menú de perfil con el estilo de la imagen
  Widget _buildStyledProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color backgroundColor =
        const Color(0xFF88D0E0), // Color azul claro de la imagen
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 6.0), // Espacio entre elementos
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: iconColor, size: 24),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor, // Color del texto y el icono
          minimumSize:
              const Size(double.infinity, 55), // Ancho completo y altura fija
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordes redondeados
          ),
          elevation: 3, // Sombra
          padding:
              const EdgeInsets.symmetric(horizontal: 20), // Padding interno
        ),
      ),
    );
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
                      onPressed: onGoHome,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Mi Perfil',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjeta de bienvenida de usuario (ajustada para el diseño de la imagen)
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Fondo gris claro como en la imagen
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person,
                        color: Colors.grey[600], size: 28), // Ícono de persona
                    const SizedBox(width: 10),
                    Text(
                      'Hola, ${userName ?? 'Usuario'}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Si quieres mostrar el nombre dinámico del usuario, aquí iría:
                    // Text(
                    //   'Hola, ${userName ?? 'Usuario'}',
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.black87,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // Sección del QR y Contactanos (ajustada para el diseño de la imagen)
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Fondo gris claro como en la imagen
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      color: Colors.white, // Fondo blanco para el QR
                      child: Center(
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón "Contactanos" con el estilo específico de la imagen
                    ElevatedButton.icon(
                      onPressed: () async {
                        const wppUrl = 'https://wa.me/50766017407';
                        if (await canLaunchUrl(Uri.parse(wppUrl))) {
                          await launchUrl(Uri.parse(wppUrl),
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Abriendo Contactanos...')),
                          );
                        }
                      },
                      icon: const Icon(Icons.send,
                          color: Colors.white), // Ícono blanco
                      label: const Text('Contáctanos',
                          style:
                              TextStyle(color: Colors.white)), // Texto blanco
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF88D0E0), // Color azul claro
                        minimumSize: const Size(
                            180, 45), // Tamaño fijo como en la imagen
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Bordes más redondeados
                        ),
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menú de opciones (usando el nuevo widget _buildStyledProfileMenuItem)

            _buildStyledProfileMenuItem(
              context: context,
              icon: Icons.person,
              title: 'Información Personal',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalInfoScreen()),
                );
              },
            ),
            _buildStyledProfileMenuItem(
              context: context,
              icon: Icons.help_outline,
              title: 'Feedback',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpCenterScreen()),
                );
              },
            ),

            if (isLoggedIn) ...[
              const SizedBox(height: 20),
              // Botón de Cerrar Sesión (con el estilo de la imagen)
              ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor:
                      const Color(0xFFCB3344), // Rojo para cerrar sesión
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
