import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/hybrid_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // No inicializar nada aquí, esperar a que se llame manualmente
    _user = null;
  }

  // Método para inicializar después de que Supabase esté listo
  void initialize() {
    try {
      _user = HybridService.currentUser;
      _listenToAuthChanges();
      notifyListeners();
    } catch (e) {
      print('Error inicializando auth: $e');
    }
  }

  void _listenToAuthChanges() {
    try {
      HybridService.authStateChanges.listen((authState) {
        _user = authState.session?.user;
        notifyListeners();
      });
    } catch (e) {
      print('Error en listener de auth: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔐 Intentando login con: $email');
      final response = await HybridService.signIn(email, password);
      _user = response.user;
      print('✅ Login exitoso: ${_user?.email}');
      return true;
    } on AuthException catch (e) {
      print('❌ Error de auth: ${e.message}');
      _error = e.message;
      return false;
    } catch (e) {
      print('❌ Error inesperado: ${e.toString()}');
      _error = 'Error inesperado: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('📝 Intentando registro con: $email');
      final response = await HybridService.signUp(email, password);
      _user = response.user;
      print('✅ Registro exitoso: ${_user?.email}');
      return true;
    } on AuthException catch (e) {
      print('❌ Error de registro: ${e.message}');
      _error = e.message;
      return false;
    } catch (e) {
      print('❌ Error inesperado en registro: ${e.toString()}');
      _error = 'Error inesperado: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await HybridService.signOut();
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
