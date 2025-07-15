# Guía Rápida de Configuración

## ⚡ Pasos para poner en funcionamiento la aplicación

### 1. Instalar dependencias
```bash
flutter pub get
```

### 2. Configurar Supabase

#### a) Crear proyecto en Supabase
1. Ve a [supabase.com](https://supabase.com)
2. Crea una cuenta gratuita
3. Crea un nuevo proyecto
4. Espera a que se configure (2-3 minutos)

#### b) Obtener credenciales
1. Ve a **Settings** > **API**
2. Copia la **URL** del proyecto
3. Copia la **clave anon/public**

#### c) Configurar la aplicación
1. Abre `lib/services/supabase_service.dart`
2. Reemplaza:
   ```dart
   static const String supabaseUrl = 'TU_URL_AQUI';
   static const String supabaseAnonKey = 'TU_CLAVE_AQUI';
   ```

#### d) Crear la base de datos
1. Ve al **SQL Editor** en Supabase
2. Copia y ejecuta el SQL del archivo `CONFIGURACION_SUPABASE.txt`

### 3. Ejecutar la aplicación
```bash
flutter run
```

## 📱 Cómo usar la app

1. **Primer uso**: Regístrate con email y contraseña
2. **Agregar visitante**: Presiona el botón ➕
3. **Completar datos**: Nombre, motivo, hora y foto (opcional)
4. **Ver lista**: Los visitantes aparecen automáticamente
5. **Detalles**: Toca un visitante para ver información completa

## 🔧 Solución de problemas comunes

**Error de dependencias:**
```bash
flutter clean
flutter pub get
```

**Error de permisos de cámara:**
- Los permisos ya están configurados en AndroidManifest.xml

**Error de conexión a Supabase:**
- Verifica que las URLs y claves sean correctas
- Asegúrate de tener conexión a internet

## ✅ Funcionalidades implementadas

- [x] Login/Registro con Supabase (25 pts)
- [x] Lista de visitantes en tiempo real (25 pts)  
- [x] Formulario de visitante completo (20 pts)
- [x] Almacenamiento y tiempo real (20 pts)
- [x] UI moderna y funcional (10 pts)

**Total: 100 puntos** ✨
