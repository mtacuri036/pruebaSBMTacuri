import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/visitor_provider.dart';
import '../models/visitor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar visitantes al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVisitors();
    });
  }

  void _loadVisitors() {
    final visitorProvider = Provider.of<VisitorProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    print('🔍 HomeScreen - Cargando visitantes...');
    print('👤 Usuario actual: ${authProvider.user?.email}');
    print('🆔 User ID: ${authProvider.user?.id}');
    
    visitorProvider.loadVisitors();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final visitorProvider = Provider.of<VisitorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Visitantes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botón de debug
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Debug info',
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final userId = authProvider.user?.id;
              
              // Hacer consulta directa para debug
              final firestore = FirebaseFirestore.instance;
              
              // Obtener TODOS los visitantes
              final allDocs = await firestore.collection('visitors').get();
              final userDocs = await firestore
                  .collection('visitors')
                  .where('user_id', isEqualTo: userId)
                  .get();
              
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Debug Info'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Email: ${authProvider.user?.email}'),
                          Text('User ID: ${userId}'),
                          Text('Total visitantes en DB: ${allDocs.docs.length}'),
                          Text('Visitantes del usuario: ${userDocs.docs.length}'),
                          const SizedBox(height: 10),
                          const Text('Todos los visitantes:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...allDocs.docs.map((doc) {
                            final data = doc.data();
                            return Text('${data['name']} - UserID: ${data['user_id']}', 
                                      style: const TextStyle(fontSize: 12));
                          }).toList(),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar visitantes',
            onPressed: () {
              print('🔄 Recarga manual solicitada');
              _loadVisitors();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Recargando visitantes...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visitantes registrados',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${visitorProvider.visitors.length} visitantes',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: visitorProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : visitorProvider.visitors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay visitantes registrados',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Agrega el primer visitante usando el botón +',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Debug info
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  border: Border.all(color: Colors.orange[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Debug Info:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                    Text(
                                      'Usuario: ${authProvider.user?.email ?? "No autenticado"}',
                                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                                    ),
                                    Text(
                                      'Lista vacía: ${visitorProvider.visitors.isEmpty}',
                                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                                    ),
                                    Text(
                                      'Error: ${visitorProvider.error ?? "Ninguno"}',
                                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: visitorProvider.visitors.length,
                          itemBuilder: (context, index) {
                            final visitor = visitorProvider.visitors[index];
                            return _buildVisitorCard(visitor);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-visitor');
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar Visitante'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildVisitorCard(Visitor visitor) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showVisitorDetails(visitor);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar o foto del visitante
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: visitor.photoUrl != null
                    ? ClipOval(
                        child: _buildVisitorImage(visitor.photoUrl!, 60, 60),
                      )
                    : Icon(
                        Icons.person,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
              ),
              const SizedBox(width: 16),
              // Información del visitante
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitor.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      visitor.reason,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(visitor.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Indicador de estado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  'Registrado',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVisitorDetails(Visitor visitor) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Detalles del Visitante'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (visitor.photoUrl != null) ...[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildVisitorImage(visitor.photoUrl!, 150, 150),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildDetailRow('Nombre:', visitor.name),
            const SizedBox(height: 8),
            _buildDetailRow('Motivo:', visitor.reason),
            const SizedBox(height: 8),
            _buildDetailRow('Fecha y hora:', dateFormat.format(visitor.timestamp)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildVisitorImage(String photoUrl, double height, double width) {
    // Si la URL empieza con 'http', es una imagen de red
    if (photoUrl.startsWith('http')) {
      return Image.network(
        photoUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: height * 0.4, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Foto no disponible',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } else {
      // Para archivos locales en modo de prueba, mostrar un placeholder
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: height * 0.4,
              color: Colors.blue[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Foto cargada',
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '(Demo local)',
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }
  }
}
