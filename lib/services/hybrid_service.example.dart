import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/visitor.dart';

class HybridService {
  // SUPABASE - Solo para autenticación y fotos
  static const String supabaseUrl = 'TU_SUPABASE_URL_AQUI';
  static const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY_AQUI';
  
  // FIREBASE - Para datos de visitantes
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Variable para almacenar el cliente una vez inicializado
  static SupabaseClient? _supabaseClient;
  
  // Getter para obtener el cliente después de la inicialización
  static SupabaseClient get supabaseClient {
    if (_supabaseClient == null) {
      throw Exception('Supabase no ha sido inicializado. Llama a HybridService.initialize() primero.');
    }
    return _supabaseClient!;
  }
  
  // Inicializar servicios
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _supabaseClient = Supabase.instance.client;
    print('✅ Supabase inicializado');
    // Firebase se inicializa en main.dart con Firebase.initializeApp()
  }
  
  // ===== AUTENTICACIÓN CON SUPABASE =====
  
  static Future<AuthResponse> signIn(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<AuthResponse> signUp(String email, String password) async {
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  static Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
  
  static User? get currentUser => supabaseClient.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => supabaseClient.auth.onAuthStateChange;
  
  // ===== DATOS DE VISITANTES CON FIREBASE =====
  
  static Future<List<Visitor>> getVisitors() async {
    final userId = currentUser?.id;
    print('🔍 getVisitors - User ID: $userId');
    if (userId == null) {
      print('⚠️ Usuario no autenticado para getVisitors');
      return [];
    }
    
    final querySnapshot = await _firestore
        .collection('visitors')
        .where('user_id', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    
    print('📊 Query result: ${querySnapshot.docs.length} documentos');
    
    final visitors = querySnapshot.docs
        .map((doc) {
          final data = {...doc.data(), 'id': doc.id};
          print('📄 Doc: ${doc.id} - ${data['name']} - ${data['user_id']}');
          return Visitor.fromJson(data);
        })
        .toList();
        
    return visitors;
  }
  
  static Future<void> addVisitor(Visitor visitor) async {
    print('💾 Guardando visitante en Firebase: ${visitor.name}');
    print('🆔 Visitor data: ${visitor.toJson()}');
    await _firestore.collection('visitors').doc(visitor.id).set(visitor.toJson());
    print('✅ Visitante guardado en Firebase');
  }
  
  static Future<void> updateVisitor(Visitor visitor) async {
    await _firestore.collection('visitors').doc(visitor.id).update(visitor.toJson());
  }
  
  static Future<void> deleteVisitor(String id) async {
    await _firestore.collection('visitors').doc(id).delete();
  }
  
  // Stream de visitantes en tiempo real con Firebase
  static Stream<List<Visitor>> getVisitorsStream() {
    final userId = currentUser?.id;
    print('🔍 getVisitorsStream - User ID: $userId');
    if (userId == null) {
      print('⚠️ Usuario no autenticado, retornando stream vacío');
      return Stream.value([]);
    }
    
    return _firestore
        .collection('visitors')
        .where('user_id', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          print('📊 Snapshot recibido: ${snapshot.docs.length} documentos');
          return snapshot.docs
              .map((doc) {
                final data = {...doc.data(), 'id': doc.id};
                print('📄 Documento: ${doc.id} - Data: $data');
                return Visitor.fromJson(data);
              })
              .toList();
        });
  }
  
  // ===== FOTOS CON SUPABASE STORAGE =====
  
  static Future<String?> uploadImage(XFile imageFile, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final bytes = await imageFile.readAsBytes();
      
      // Subir imagen a Supabase Storage
      await supabaseClient.storage
          .from('visitor-photos')
          .uploadBinary('$userId/$fileName', bytes);
      
      // Obtener URL pública
      final imageUrl = supabaseClient.storage
          .from('visitor-photos')
          .getPublicUrl('$userId/$fileName');
      
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Supabase: $e');
      // En caso de error, devolver null para que la app siga funcionando sin imagen
      return null;
    }
  }
  
  // Verificar si Supabase Storage está configurado correctamente
  static Future<bool> isStorageConfigured() async {
    try {
      final buckets = await supabaseClient.storage.listBuckets();
      return buckets.any((bucket) => bucket.name == 'visitor-photos');
    } catch (e) {
      print('Supabase Storage not configured: $e');
      return false;
    }
  }
}
