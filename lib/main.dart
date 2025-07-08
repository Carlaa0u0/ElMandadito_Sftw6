import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'widgets/login_prompt_sheet.dart';

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
  String? _userName = 'Papito';

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

  void _simulateLogin() {
    setState(() {
      _isLoggedIn = true;
      _userName = 'Papito'; // O actualízalo según el usuario real
      _currentIndex = 1;
      _buildScreens();
    });
  }

  void showLoginPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return LoginPromptSheet(
          onLogin: () {
            Navigator.pop(context);
            _simulateLogin();
          },
          onRegister: () {
            Navigator.pop(context);
            _simulateLogin();
          },
        );
      },
    );
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
            // Si el usuario toca Perfil o Carrito y no está logueado, muestra login
            if ((index == 1 || index == 2) && !_isLoggedIn) {
              showLoginPrompt(context);
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          ],
        ),
      ),
    );
  }
}
