# 🛠️ Comandos de instalación y ejecución

## 1. Instalar dependencias
```powershell
flutter pub get
```

## 2. Limpiar proyecto (si hay errores)
```powershell
flutter clean
flutter pub get
```

## 3. Verificar instalación
```powershell
flutter doctor
flutter analyze
```

## 4. Ejecutar en emulador/dispositivo
```powershell
flutter run
```

## 5. Ejecutar en modo debug
```powershell
flutter run --debug
```

## 6. Ejecutar en modo release
```powershell
flutter run --release
```

## 🔥 Configuración Firebase (IMPORTANTE)

Después de crear tu proyecto en Firebase Console:

1. Descarga `google-services.json`
2. Colócalo en: `android/app/google-services.json`
3. Ejecuta: `flutter clean && flutter pub get`

## 🔐 Configuración Supabase (IMPORTANTE)

En el archivo `lib/services/hybrid_service.dart`, reemplaza:

```dart
static const String supabaseUrl = 'TU_URL_DE_SUPABASE_AQUI';
static const String supabaseAnonKey = 'TU_CLAVE_ANON_AQUI';
```

Con tus credenciales reales de Supabase.

## 📱 Permisos Android

Si tienes problemas con la cámara, asegúrate de que estos permisos estén en `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## ❗ Solución de errores comunes

### Error de dependencias
```powershell
flutter pub deps
flutter pub upgrade --major-versions
```

### Error de build
```powershell
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

### Error de Firebase
1. Verifica `google-services.json` en `android/app/`
2. Confirma que el package name coincida
3. Ejecuta `flutter clean && flutter pub get`
