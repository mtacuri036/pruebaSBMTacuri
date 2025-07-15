# 🔐 Cómo obtener URL y clave de Supabase

## 📍 Paso a paso para obtener las credenciales

### 1. Ir a Supabase Dashboard
- Ve a: https://supabase.com/dashboard
- Inicia sesión con tu cuenta

### 2. Seleccionar tu proyecto
- Haz clic en tu proyecto (registro-visitantes o como lo hayas nombrado)
- Si no tienes proyecto, créalo primero

### 3. Obtener las credenciales

1. **En el menú lateral izquierdo**, haz clic en **"Settings"** (Configuración)
2. **Haz clic en "API"**
3. Verás dos valores importantes:

#### 🌐 Project URL (URL del proyecto)
```
https://xxxxxxxxxxxxxxxx.supabase.co
```
- Copia esta URL completa
- Ejemplo: `https://sefqqbkhoexhgkggxvuz.supabase.co`

#### 🔑 API Keys
Verás varias claves, necesitas la **"anon public"**:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlZnFxYmtob...
```
- Es una clave muy larga que empieza con `eyJ`
- **NO uses la "service_role"** (esa es privada)

### 4. Actualizar el código

En `lib/services/hybrid_service.dart`, reemplaza:

```dart
static const String supabaseUrl = 'TU_URL_DE_SUPABASE_AQUI';
static const String supabaseAnonKey = 'TU_CLAVE_ANON_AQUI';
```

Con tus valores reales:

```dart
static const String supabaseUrl = 'https://xxxxxxxxxxxxxxxx.supabase.co';
static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlZnFxYmtob...';
```

## 🖼️ Ubicación visual en Supabase Dashboard

```
Dashboard de Supabase
├── Mi Proyecto
│   ├── [Menú lateral]
│   │   ├── Table Editor
│   │   ├── Authentication
│   │   ├── Storage
│   │   └── ⚙️ Settings  ← HAZ CLIC AQUÍ
│   │       └── 📡 API   ← LUEGO AQUÍ
│   │           ├── 🌐 Project URL: https://xxx.supabase.co
│   │           └── 🔑 API Keys:
│   │               ├── anon public: eyJhbGci... ← USA ESTA
│   │               └── service_role: eyJhbGci... ← NO USES ESTA
```

## ⚠️ Importante

- **anon public**: Segura para usar en el frontend
- **service_role**: NUNCA la uses en el frontend (es administrativa)
- **Project URL**: Siempre termina en `.supabase.co`

## 🧪 Verificar que están correctas

Después de actualizar:
```bash
flutter pub get
flutter run
```

Si las credenciales están bien, la app debería:
- Permitir registro/login
- No mostrar errores de conexión

## 💡 Ejemplo real

Tu archivo debería verse así:
```dart
static const String supabaseUrl = 'https://abcdefghijklmnop.supabase.co';
static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYxMjM0NTY3OCwiZXhwIjoxOTI3OTIxNjc4fQ.abc123def456ghi789';
```

¿Ya encontraste las credenciales? Te ayudo a actualizarlas en el código.
