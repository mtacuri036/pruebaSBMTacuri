# 📋 Registro de Visitantes

Una aplicación Flutter moderna para el registro y gestión de visitantes en oficinas, con autenticación segura y almacenamiento híbrido.

## 🚀 Características

- **Autenticación segura** con Supabase
- **Registro de visitantes** con datos completos (nombre, motivo, fecha/hora)
- **Captura y almacenamiento de fotos** en Supabase Storage
- **Base de datos en tiempo real** con Firebase Firestore
- **Interfaz moderna** con Material Design 3
- **Multiplataforma** (Android, iOS, Web, Windows, macOS, Linux)

## 🛠️ Tecnologías Utilizadas

- **Flutter** ^3.8.1 - Framework de desarrollo
- **Supabase** - Autenticación y almacenamiento de imágenes
- **Firebase Firestore** - Base de datos en tiempo real
- **Provider** - Gestión de estado
- **Material Design 3** - Diseño de interfaz
- **Manejo de estado**: Provider
- **Capturas de imagen**: Image Picker
- **Validaciones**: Form Builder Validators

## Configuración inicial

### 1. Configurar Supabase

1. Ve a [Supabase](https://supabase.com) y crea una nueva cuenta/proyecto
2. Crea una nueva base de datos
3. En el panel de Supabase, ve a "Settings" > "API" y copia:
   - URL del proyecto
   - Clave anon/public

### 2. Configurar la base de datos

Ejecuta el siguiente SQL en el editor SQL de Supabase:

```sql
-- Crear tabla de visitantes
CREATE TABLE visitors (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  reason TEXT NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL,
  photo_url TEXT,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar RLS (Row Level Security)
ALTER TABLE visitors ENABLE ROW LEVEL SECURITY;

-- Crear política para que los usuarios solo vean sus propios visitantes
CREATE POLICY "Users can view own visitors" ON visitors
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own visitors" ON visitors
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own visitors" ON visitors
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own visitors" ON visitors
  FOR DELETE USING (auth.uid() = user_id);

-- Crear bucket para fotos de visitantes
INSERT INTO storage.buckets (id, name, public) VALUES ('visitor-photos', 'visitor-photos', true);

-- Crear política para el bucket de fotos
CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING (bucket_id = 'visitor-photos');
CREATE POLICY "Authenticated users can upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'visitor-photos' AND auth.role() = 'authenticated');
```

### 3. Configurar la aplicación

1. Abre el archivo `lib/services/supabase_service.dart`
2. Reemplaza las siguientes constantes con tus datos de Supabase:

```dart
static const String supabaseUrl = 'TU_URL_DE_SUPABASE';
static const String supabaseAnonKey = 'TU_CLAVE_ANON';
```

### 4. Instalar dependencias

```bash
flutter pub get
```

### 5. Configurar permisos (Android)

Agrega estos permisos en `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 6. Ejecutar la aplicación

```bash
flutter run
```

## Estructura del proyecto

```
lib/
├── main.dart                   # Punto de entrada de la aplicación
├── models/
│   └── visitor.dart           # Modelo de datos del visitante
├── providers/
│   ├── auth_provider.dart     # Manejo de estado de autenticación
│   └── visitor_provider.dart  # Manejo de estado de visitantes
├── screens/
│   ├── login_screen.dart      # Pantalla de login
│   ├── home_screen.dart       # Pantalla principal con lista
│   └── add_visitor_screen.dart # Pantalla para agregar visitantes
└── services/
    └── supabase_service.dart   # Servicios de Supabase
```

## Funcionalidades implementadas

### 1. Pantalla de Login (25 pts)
- ✅ Formulario con validación de correo y contraseña
- ✅ Integración con Supabase Auth
- ✅ Manejo de errores y estados de carga
- ✅ Opción de registro para nuevos usuarios

### 2. Pantalla Principal (25 pts)
- ✅ Lista de visitantes en tiempo real
- ✅ Muestra nombre, motivo y hora de cada visitante
- ✅ Diseño responsivo con cards
- ✅ Información del usuario logueado

### 3. Formulario de Visitante (20 pts)
- ✅ Campo de nombre con validación (5 pts)
- ✅ Campo de motivo con validación (5 pts)
- ✅ Selector de fecha/hora con timestamp (5 pts)
- ✅ Captura/selección de foto (5 pts)

### 4. Almacenamiento y Tiempo Real (20 pts)
- ✅ Guardado en Supabase con relación al usuario
- ✅ Actualización automática de la lista
- ✅ Subida de imágenes a Supabase Storage
- ✅ Manejo de errores y validaciones

### 5. Presentación y UI (10 pts)
- ✅ Diseño moderno y funcional
- ✅ Navegación intuitiva
- ✅ Validaciones de campos
- ✅ Feedback visual al usuario

## Cómo probar la aplicación

1. **Registro/Login**: 
   - Crea una cuenta nueva o inicia sesión
   - Las credenciales se validan con Supabase

2. **Agregar visitante**:
   - Presiona el botón "Agregar Visitante"
   - Completa todos los campos requeridos
   - Opcionalmente toma una foto
   - Guarda el visitante

3. **Ver lista**:
   - La lista se actualiza automáticamente
   - Toca un visitante para ver sus detalles
   - Las fotos se cargan desde Supabase Storage

## Notas técnicas

- **Tiempo real**: Implementado con Supabase Realtime
- **Seguridad**: Row Level Security habilitado
- **Imágenes**: Optimizadas y subidas a Supabase Storage
- **Estado**: Manejado con Provider pattern
- **Validaciones**: Formularios validados en frontend y backend

## Solución de problemas

1. **Error de conexión a Supabase**: Verifica URL y claves de API
2. **Permisos de cámara**: Asegúrate de tener los permisos en AndroidManifest
3. **Problemas de compilación**: Ejecuta `flutter clean` y `flutter pub get`

## Créditos

Desarrollado como proyecto de evaluación para aplicaciones móviles.
