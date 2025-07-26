import 'package:flutter/material.dart';

/// Clase AuthProvider
/// Gestiona el estado de autenticación del usuario (logueado/no logueado y nombre de usuario).
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false; // Estado de inicio de sesión.
  String? _userName;        // Nombre del usuario logueado.

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  /// Inicia sesión del usuario.
  /// Importante: Actualiza el estado a logueado y notifica a los oyentes.
  void login(String name) {
    _isLoggedIn = true;
    _userName = name;
    notifyListeners();
  }

  /// Cierra la sesión del usuario.
  /// Importante: Restablece el estado a no logueado y notifica a los oyentes.
  void logout() {
    _isLoggedIn = false;
    _userName = null;
    notifyListeners();
  }
}