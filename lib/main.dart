import 'package:appwrite/appwrite.dart' as models;
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
import 'services/appwrite_service.dart';
import 'package:appwrite/models.dart' as models;

void main() {
  runApp(const MyApp());
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
  String? _userId;

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
            _userId = null;
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
        userId: _userId ?? '',
      ),
    ];
  }

  void _handleAuthSuccess(String name, String userId) {
    setState(() {
      _isLoggedIn = true;
      _userName = name;
      _userId = userId;
      _currentIndex = 1;
      _buildScreens();
    });
  }

  Future<void> _showLoginPrompt(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext ctx) {
        return LoginPromptSheet(
          onLogin: () async {
            Navigator.pop(ctx);
            final result = await Navigator.pushNamed(context, '/login_screen');
            if (result == true) {
              final account = Account(AppwriteService.client);
              final models.User userAccount = await account.get();
              _handleAuthSuccess(userAccount.name, userAccount.$id);
            }
          },
          onRegister: () async {
            Navigator.pop(ctx);
            final result =
                await Navigator.pushNamed(context, '/register_screen');
            if (result == true) {
              final account = Account(AppwriteService.client);
              final models.User userAccount = await account.get();
              _handleAuthSuccess(userAccount.name, userAccount.$id);
            }
          },
        );
      },
    );
  }

  // Función lista para llamar al backend Stripe si se requiere:
  Future<void> _iniciarPagoStripe() async {
    try {
      final url = Uri.parse('http://localhost:3000/create-checkout-session');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['url'];
        if (await canLaunch(checkoutUrl)) {
          await launch(checkoutUrl, forceSafariVC: false, forceWebView: false);
        } else {
          throw 'No se pudo abrir Stripe Checkout';
        }
      } else {
        throw 'Error creando sesión: ${response.body}';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar pago: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
