import 'package:flutter/material.dart';
import '../models/visitor.dart';
import '../services/hybrid_service.dart';

class VisitorProvider extends ChangeNotifier {
  List<Visitor> _visitors = [];
  bool _isLoading = false;
  String? _error;

  List<Visitor> get visitors => _visitors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  VisitorProvider() {
    // No inicializar nada aquí
  }

  // Método para inicializar después de que los servicios estén listos
  void initialize() {
    try {
      print('🔄 Inicializando listener de visitantes...');
      // Escuchar cambios en tiempo real desde Firebase
      HybridService.getVisitorsStream().listen(
        (visitors) {
          print('📱 Recibidos ${visitors.length} visitantes del stream');
          _visitors = visitors;
          notifyListeners();
        },
        onError: (error) {
          print('❌ Error en stream de visitantes: $error');
          _error = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      print('❌ Error inicializando listeners: $e');
    }
  }

  Future<void> loadVisitors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 Cargando visitantes manualmente...');
      _visitors = await HybridService.getVisitors();
      print('📋 Visitantes cargados: ${_visitors.length}');
    } catch (e) {
      print('❌ Error cargando visitantes: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVisitor(Visitor visitor) async {
    try {
      print('➕ Agregando visitante: ${visitor.name} (User ID: ${visitor.userId})');
      await HybridService.addVisitor(visitor);
      print('✅ Visitante agregado correctamente');
      
      // Forzar recarga manual como respaldo
      await loadVisitors();
      
      // El listener en tiempo real actualizará la lista automáticamente
    } catch (e) {
      print('❌ Error agregando visitante: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateVisitor(Visitor visitor) async {
    try {
      await HybridService.updateVisitor(visitor);
      // El listener en tiempo real actualizará la lista automáticamente
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteVisitor(String id) async {
    try {
      await HybridService.deleteVisitor(id);
      // El listener en tiempo real actualizará la lista automáticamente
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
