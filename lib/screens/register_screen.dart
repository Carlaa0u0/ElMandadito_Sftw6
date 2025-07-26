import 'package:flutter/material.dart';
import 'package:flutter_proyecto_1/widgets/custom_header_painter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: CustomHeaderPainter(),
                  ),
                ),
                const Positioned(
                  top: 80,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '¡Crea tu cuenta!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField('Nombre', _nameController, Icons.person),
                  const SizedBox(height: 15),
                  _buildTextField('Correo', _emailController, Icons.email),
                  const SizedBox(height: 15),
                  _buildTextField('Contraseña', _passwordController, Icons.lock, obscureText: true),
                  const SizedBox(height: 15),
                  _buildTextField('Confirmar Contraseña', _confirmPasswordController, Icons.lock, obscureText: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // **Aquí va tu lógica de registro real.**
                      // Para evitar el "Dead code" y poder probar el SnackBar de error,
                      // temporalmente lo establecemos en 'false'.
                      // En tu implementación real, esto dependerá del resultado de tu API.
                      bool registerSuccessful = false; // CAMBIADO A 'false' PARA PROBAR EL SNACKBAR DE ERROR

                      // ignore: dead_code
                      if (registerSuccessful) {
                        // IMPORTANTE: Devuelve 'true' al Navigator que la llamó.
                        // Esto hará que el 'await' en MainPage reciba 'true'.
                        Navigator.of(context).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al registrar usuario. Por favor, intenta de nuevo.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navega a la pantalla de login usando la ruta con nombre
                      // No esperamos resultado aquí, ya que la navegación es hacia adelante.
                      Navigator.pushNamed(context, '/login_screen');
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: '¿Ya tienes una cuenta? ',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                        children: [
                          TextSpan(
                            text: '¡Inicia Sesión!',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueGrey.shade100, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueGrey.shade100, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.cyan.shade300, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}
