import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/visitor.dart';
import 'dart:io';

class SupabaseService {
  // INSTRUCCIONES: Reemplaza estos valores con los de tu proyecto Supabase
  static const String supabaseUrl = 'https://sefqqbkhoexhgkggxvuz.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlZnFxYmtob2V4aGdrZ2d4dnV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MDg3NjksImV4cCI6MjA2ODE4NDc2OX0.5OUdOKsXIrrOJyZxmS_TYFCQmfgH8zU6Vh18kkAq4Ps';
  
  static final SupabaseClient _client = Supabase.instance.client;
  
  static SupabaseClient get client => _client;
  
  // Inicializar Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  // Autenticación
  static Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  static User? get currentUser => _client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Operaciones con visitantes
  static Future<List<Visitor>> getVisitors() async {
    final userId = currentUser?.id;
    if (userId == null) return [];
    
    final response = await _client
        .from('visitors')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false);
    
    return (response as List)
        .map((json) => Visitor.fromJson(json))
        .toList();
  }
  
  static Future<void> addVisitor(Visitor visitor) async {
    await _client.from('visitors').insert(visitor.toJson());
  }
  
  static Future<void> updateVisitor(Visitor visitor) async {
    await _client
        .from('visitors')
        .update(visitor.toJson())
        .eq('id', visitor.id);
  }
  
  static Future<void> deleteVisitor(String id) async {
    await _client.from('visitors').delete().eq('id', id);
  }
  
  // Stream de visitantes en tiempo real
  static Stream<List<Visitor>> getVisitorsStream() {
    final userId = currentUser?.id;
    if (userId == null) return Stream.value([]);
    
    return _client
        .from('visitors')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .map((data) => data.map((json) => Visitor.fromJson(json)).toList());
  }
  
  // Subir imagen
  static Future<String?> uploadImage(String filePath, String fileName) async {
    try {
      await _client.storage
          .from('visitor-photos')
          .upload(fileName, File(filePath));
      
      return _client.storage
          .from('visitor-photos')
          .getPublicUrl(fileName);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
