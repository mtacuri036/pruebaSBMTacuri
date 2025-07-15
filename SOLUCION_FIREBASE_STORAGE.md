# 🔥 Solución: Error de Firebase Storage - Región sin bucket gratuito

## 🚨 El problema
Firebase muestra: "La ubicación de tus datos se estableció en una región que no admite buckets de Storage sin costo"

## ✅ Solución paso a paso

### Opción 1: Crear bucket en región compatible (RECOMENDADO)

1. **Ir a Firebase Console**:
   - Ve a tu proyecto en https://console.firebase.google.com/
   - Navega a "Storage" en el menú lateral

2. **Crear bucket manualmente**:
   - Haz clic en "Comenzar" o "Crear bucket"
   - **Región**: Selecciona una de estas regiones gratuitas:
     - `us-central1` (Iowa)
     - `us-west1` (Oregon) 
     - `us-east1` (South Carolina)
   - Haz clic en "Continuar"
   - Modo: "Iniciar en modo de prueba"
   - Haz clic en "Listo"

### Opción 2: Cambiar región del proyecto (SI ES NUEVO)

Si tu proyecto es muy nuevo y no tiene datos importantes:

1. **Crear nuevo proyecto**:
   - Ve a Firebase Console
   - Crea un nuevo proyecto
   - **Importante**: En "Configuración del proyecto" → "General"
   - Selecciona región: `us-central1` o `us-west1`

2. **Reconfigurar app**:
   - Descarga el nuevo `google-services.json`
   - Reemplázalo en `android/app/google-services.json`

### Opción 3: Usar plan Blaze (PAGO)

Si necesitas tu región específica:
1. Ve a "Configuración" → "Uso y facturación"
2. Actualiza al plan "Blaze" (pay-as-you-go)
3. Tendrás límites generosos gratuitos incluso en el plan de pago

## 🔧 Configurar reglas de Storage

Una vez creado el bucket:

1. **Ir a Storage** → **Reglas**
2. **Reemplazar con estas reglas**:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir lectura/escritura para usuarios autenticados en sus carpetas
    match /visitor-photos/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Permitir lectura pública de imágenes (opcional)
    match /visitor-photos/{userId}/{allPaths=**} {
      allow read: if true;
    }
  }
}
```

3. **Publicar** las reglas

## 🧪 Probar Storage

Después de configurar:

1. **Ejecutar la app**:
```bash
flutter run
```

2. **Probar subida de imagen**:
   - Crear cuenta/iniciar sesión
   - Agregar visitante con foto
   - Verificar que la imagen aparezca

3. **Verificar en Firebase Console**:
   - Ve a Storage → Files
   - Deberías ver carpeta `visitor-photos/[user-id]/[imagen.jpg]`

## 📍 Regiones recomendadas para plan gratuito

✅ **Funcionan sin costo**:
- `us-central1` (Iowa) - **MÁS RECOMENDADA**
- `us-west1` (Oregon)
- `us-east1` (South Carolina)

❌ **Requieren plan Blaze**:
- `europe-west1` (Bélgica)
- `asia-southeast1` (Singapur)
- La mayoría de regiones fuera de US

## 🚨 Si sigue fallando

1. **Verificar inicialización**:
   - Asegúrate de que `google-services.json` esté en la ubicación correcta
   - Ejecuta: `flutter clean && flutter pub get`

2. **Verificar permisos**:
   - Ve a Storage → Reglas
   - Confirma que las reglas permitan tu operación

3. **Logs de debug**:
```bash
flutter run --verbose
```

4. **Alternativa temporal** - Usar solo texto sin imágenes:
   - Comentar la línea de subida de imagen
   - Probar que todo lo demás funcione

## 💡 Consejo

Para desarrollo inicial, usa `us-central1`. Es la región más estable y compatible con todos los servicios gratuitos de Firebase.
