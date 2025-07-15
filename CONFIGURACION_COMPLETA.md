# 🚀 Configuración Completa - Supabase + Firebase

## 📋 Resumen
Tu app ahora usa un sistema híbrido:
- **Supabase**: Autenticación de usuarios
- **Firebase**: Datos de visitantes + Almacenamiento de imágenes

## 🔥 PARTE 1: Configuración de Firebase

### 1.1 Crear Proyecto en Firebase Console
1. Ve a https://console.firebase.google.com/
2. Haz clic en "Crear un proyecto"
3. Nombre: `registro-visitantes` (o el que prefieras)
4. Habilita Google Analytics (opcional)
5. Completa la creación

### 1.2 Configurar Firebase para Android
1. En la consola de Firebase, haz clic en "Agregar app" → Ícono de Android
2. Paquete de Android: `com.example.registro_visitantes`
3. Apodo de la app: "Registro Visitantes Android"
4. Descarga `google-services.json`
5. Coloca el archivo en: `android/app/google-services.json`

### 1.3 Habilitar servicios en Firebase
1. **Firestore Database**:
   - Ve a "Firestore Database" → "Crear base de datos"
   - Modo: "Iniciar en modo de prueba"
   - Ubicación: Selecciona la más cercana

2. **Storage**:
   - Ve a "Storage" → "Comenzar"
   - Modo: "Iniciar en modo de prueba"

### 1.4 Configurar reglas de seguridad

**Firestore Rules** (Firestore Database → Reglas):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo usuarios autenticados pueden leer/escribir sus propios datos
    match /visitors/{document} {
      allow read, write: if request.auth != null && 
                         request.auth.uid == resource.data.user_id;
      allow create: if request.auth != null && 
                    request.auth.uid == request.resource.data.user_id;
    }
  }
}
```

**Storage Rules** (Storage → Reglas):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /visitor-photos/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🔐 PARTE 2: Configuración de Supabase

### 2.1 Crear Proyecto en Supabase
1. Ve a https://supabase.com/dashboard
2. Haz clic en "New project"
3. Selecciona tu organización
4. Nombre: `registro-visitantes`
5. Database Password: **Guarda esta contraseña**
6. Region: Selecciona la más cercana
7. Haz clic en "Create new project"

### 2.2 Obtener credenciales
1. Ve a "Settings" → "API"
2. Copia:
   - **Project URL**: `https://xxxxxxxx.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

### 2.3 Actualizar código con credenciales
En `lib/services/hybrid_service.dart`, reemplaza:
```dart
static const String supabaseUrl = 'TU_URL_DE_SUPABASE_AQUI';
static const String supabaseAnonKey = 'TU_CLAVE_ANON_AQUI';
```

Por tus credenciales reales:
```dart
static const String supabaseUrl = 'https://xxxxxxxx.supabase.co';
static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### 2.4 Configurar autenticación en Supabase
1. Ve a "Authentication" → "Settings"
2. En "Site URL", agrega: `com.example.registro_visitantes://`
3. En "Redirect URLs", agrega el mismo URL
4. Guarda los cambios

## 📱 PARTE 3: Instalación y prueba

### 3.1 Instalar dependencias
```bash
flutter pub get
flutter pub upgrade
```

### 3.2 Verificar configuración
```bash
flutter doctor
flutter analyze
```

### 3.3 Ejecutar en dispositivo
```bash
flutter run
```

## 🧪 PARTE 4: Probar la app

### 4.1 Crear cuenta de prueba
1. Abre la app
2. Haz clic en "Registrarse"
3. Usa un email real: `test@example.com`
4. Contraseña: `123456789`

### 4.2 Verificar funcionalidades
1. **Login**: Iniciar sesión con las credenciales
2. **Agregar visitante**: Tomar foto y guardar datos
3. **Ver lista**: Los visitantes aparecen en tiempo real
4. **Ver detalles**: Modal con información completa

## 🔧 PARTE 5: Solución de problemas comunes

### Firebase no conecta
- Verifica que `google-services.json` esté en `android/app/`
- Revisa que el package name coincida
- Ejecuta `flutter clean && flutter pub get`

### Supabase no autentica
- Verifica las URLs en `hybrid_service.dart`
- Confirma que las reglas de auth están habilitadas
- Revisa la consola de Supabase para logs

### Imágenes no cargan
- Verifica las reglas de Storage en Firebase
- Confirma que el usuario esté autenticado
- Revisa los permisos de cámara en el dispositivo

## 📊 PARTE 6: Monitoreo

### Ver datos en tiempo real
- **Firebase Console**: Firestore Database → Data
- **Supabase Dashboard**: Authentication → Users

### Logs y debugging
- **Firebase**: Consola → Logs
- **Supabase**: Dashboard → Logs
- **Flutter**: `flutter logs`

## 🎉 ¡Listo!

Tu app está configurada con:
✅ Autenticación segura con Supabase
✅ Base de datos en tiempo real con Firebase
✅ Almacenamiento de imágenes en la nube
✅ Interfaz moderna y responsive

Para producción, recuerda:
- Configurar reglas de seguridad más estrictas
- Agregar validación adicional
- Configurar backup automático
- Monitorear uso y rendimiento
