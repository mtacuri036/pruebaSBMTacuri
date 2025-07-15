import 'package:flutter/material.dart';
import '../models/visitor.dart';

// Servicio de prueba local para desarrollo sin Supabase
class LocalTestService {
  static final List<Visitor> _visitors = [];
  static bool _isAuthenticated = false;
  static String? _currentUserId;

  // Autenticación de prueba
  static Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simular carga
    if (email.isNotEmpty && password.length >= 6) {
      _isAuthenticated = true;
      _currentUserId = 'test-user-id';
      return true;
    }
    return false;
  }

  static Future<bool> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.length >= 6) {
      _isAuthenticated = true;
      _currentUserId = 'test-user-id';
      return true;
    }
    return false;
  }

  static Future<void> signOut() async {
    _isAuthenticated = false;
    _currentUserId = null;
  }

  static bool get isAuthenticated => _isAuthenticated;
  static String? get currentUserId => _currentUserId;

  // Operaciones con visitantes
  static Future<List<Visitor>> getVisitors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _visitors.where((v) => v.userId == _currentUserId).toList();
  }

  static Future<void> addVisitor(Visitor visitor) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _visitors.add(visitor);
  }

  static Future<void> updateVisitor(Visitor visitor) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _visitors.indexWhere((v) => v.id == visitor.id);
    if (index != -1) {
      _visitors[index] = visitor;
    }
  }

  static Future<void> deleteVisitor(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _visitors.removeWhere((v) => v.id == id);
  }

  // Simular subida de imagen
  static Future<String?> uploadImage(String filePath, String fileName) async {
    await Future.delayed(const Duration(seconds: 2));
    // Retornar el path local para uso en la demo
    // En producción con Supabase esto sería una URL real
    return filePath;
  }
}
