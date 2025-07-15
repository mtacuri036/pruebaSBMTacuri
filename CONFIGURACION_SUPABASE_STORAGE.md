# 📸 Configuración de Supabase Storage para Imágenes

## 🎯 Nueva arquitectura simplificada

- **Supabase**: Autenticación + Storage de imágenes
- **Firebase**: Solo datos de visitantes (Firestore)

Esto evita completamente los problemas de región de Firebase Storage.

## 🔧 Configurar Supabase Storage

### 1. Crear bucket en Supabase

1. **Ve a Supabase Dashboard**: https://supabase.com/dashboard
2. **Selecciona tu proyecto**
3. **Ve a "Storage"** en el menú lateral
4. **Haz clic en "Create bucket"**
5. **Configuración del bucket**:
   - **Name**: `visitor-photos`
   - **Public bucket**: ✅ **SÍ** (marca esta casilla)
   - **File size limit**: `10MB`
   - **Allowed MIME types**: `image/*`
6. **Haz clic en "Create bucket"**

### 2. Configurar políticas de seguridad (RLS)

1. **Ve a "Storage"** → **Policies**
2. **Haz clic en "New policy"** para el bucket `visitor-photos`

**Política 1: Permitir subida**
- **Policy name**: `Users can upload their own photos`
- **Allowed operation**: `INSERT`
- **Target roles**: `authenticated`
- **Policy definition**:
```sql
((bucket_id = 'visitor-photos'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text))
```

**Política 2: Permitir lectura**
- **Policy name**: `Anyone can view photos`
- **Allowed operation**: `SELECT`
- **Target roles**: `public`
- **Policy definition**:
```sql
(bucket_id = 'visitor-photos'::text)
```

**Política 3: Permitir actualización**
- **Policy name**: `Users can update their own photos`
- **Allowed operation**: `UPDATE`
- **Target roles**: `authenticated`
- **Policy definition**:
```sql
((bucket_id = 'visitor-photos'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text))
```

**Política 4: Permitir eliminación**
- **Policy name**: `Users can delete their own photos`
- **Allowed operation**: `DELETE`
- **Target roles**: `authenticated`
- **Policy definition**:
```sql
((bucket_id = 'visitor-photos'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text))
```

### 3. Configurar solo Firestore (sin Storage)

En Firebase Console:

1. **Ve a "Firestore Database"**
2. **Crear base de datos** (si no existe)
3. **Modo**: "Iniciar en modo de prueba"
4. **Configurar reglas**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /visitors/{document} {
      allow read, write: if request.auth != null && 
                         request.auth.uid == resource.data.user_id;
      allow create: if request.auth != null && 
                    request.auth.uid == request.resource.data.user_id;
    }
  }
}
```

## 🧪 Probar la configuración

### 1. Instalar dependencias actualizadas

```bash
flutter pub get
```

### 2. Ejecutar la app

```bash
flutter run
```

### 3. Probar funcionalidades

1. **Registrar/Login** (Supabase Auth)
2. **Agregar visitante con foto** (Foto → Supabase, Datos → Firebase)
3. **Ver lista** (Firestore + imágenes de Supabase)

## ✅ Ventajas de esta arquitectura

- ✅ **Sin problemas de región** en Storage
- ✅ **Supabase Storage es completamente gratis**
- ✅ **Firebase Firestore también gratis** hasta límites generosos
- ✅ **Más simple de configurar**
- ✅ **Mejor rendimiento** (menos servicios)

## 🔍 Verificar que funciona

### En Supabase Dashboard:
- **Storage** → **visitor-photos**: Deberías ver carpetas por usuario
- **Authentication** → **Users**: Usuarios registrados

### En Firebase Console:
- **Firestore Database** → **Data**: Colección `visitors` con documentos

## 🚨 Si hay problemas

1. **Verificar bucket público**: Storage → visitor-photos → Settings → Public = ✅
2. **Verificar políticas**: Storage → Policies → 4 políticas activas
3. **Logs**: `flutter run --verbose`

## 📱 URLs de las imágenes

Las imágenes ahora tendrán URLs como:
```
https://xxxxxxxx.supabase.co/storage/v1/object/public/visitor-photos/user-id/imagen.jpg
```

¡Mucho más simple y sin costos adicionales!
