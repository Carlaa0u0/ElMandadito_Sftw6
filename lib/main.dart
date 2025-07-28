// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/product_detail_screen.dart'; 
import 'screens/personal_info_screen.dart'; 
import 'screens/help_center_screen.dart'; 
import 'screens/purchase_history_screen.dart'; 

import 'widgets/login_prompt_sheet.dart';

// api de comida
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  runApp(const MyApp());

  //agente usuario api comida

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'El Mandadito',
    version: '1.0.0',
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Mandadito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
          secondary: Colors.redAccent,
        ),
        useMaterial3: true,
      ),
      // Definimos las rutas con nombre aquí
      routes: {
        '/login_screen': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        
      },
      home: const MainPage(), 
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  String? _userName = 'Usuario'; 

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _buildScreens(); 
  }

  void _buildScreens() {
    _screens = [
      const HomeScreen(), 
      ProfileScreen(
        onGoHome: () {
          setState(() {
            _currentIndex = 0; 
          });
        },
        isLoggedIn: _isLoggedIn, 
        userName: _userName, 
        onLogout: () {
          
          setState(() {
            _isLoggedIn = false;
            _userName = null; 
            _currentIndex = 0; 
            _buildScreens(); 
          });
        },
      ),
      CartScreen(
        onGoHome: () {
          setState(() {
            _currentIndex = 0; 
          });
        },
      ),
    ];
  }

  // Método para simular el inicio de sesión y actualizar el estado
  void _handleAuthSuccess(String name) {
    setState(() {
      _isLoggedIn = true;
      _userName = name;
      _currentIndex = 1; // Navega a la pestaña de Perfil después del login
      _buildScreens(); // Reconstruye las pantallas con el nuevo estado
    });
  }

  // Función para mostrar el BottomSheet de login/registro
  Future<void> _showLoginPrompt(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext ctx) {
        return LoginPromptSheet(
          onLogin: () async {
            Navigator.pop(ctx);
            final loginResult =
                await Navigator.pushNamed(context, '/login_screen');
            if (loginResult == true) {
              _handleAuthSuccess(_userName ?? 'Usuario');
            }
          },
          onRegister: () async {
            Navigator.pop(ctx);
            final registerResult =
                await Navigator.pushNamed(context, '/register_screen');
            if (registerResult == true) {
              _handleAuthSuccess(_userName ?? 'Usuario');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Muestra la pantalla actual
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: const Color(0xFFCB3344),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) {
            if ((index == 1 || index == 2) && !_isLoggedIn) {
              _showLoginPrompt(context);
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          ],
        ),
      ),
    );
  }
}