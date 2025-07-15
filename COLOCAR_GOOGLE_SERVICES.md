# ⚠️ INSTRUCCIONES PARA google-services.json

## 📁 Ubicación correcta

El archivo `google-services.json` debe ir en:
```
android/app/google-services.json
```

## 📋 Pasos para colocarlo

1. **Descarga** `google-services.json` desde Firebase Console
2. **Copia** el archivo
3. **Pega** en la carpeta: `android/app/`
4. **Verifica** que quede así:

```
proyecto/
├── android/
│   ├── app/
│   │   ├── google-services.json  ← AQUÍ
│   │   ├── build.gradle.kts
│   │   └── src/
│   └── build.gradle.kts
├── lib/
└── pubspec.yaml
```

## ✅ Verificar que está bien colocado

Ejecuta este comando para verificar:
```bash
dir android\app\google-services.json
```

Si aparece el archivo, está bien colocado.

## 🚨 Si no aparece el archivo

- Verifica que descargaste el archivo correcto desde Firebase
- Asegúrate de que no esté en una subcarpeta
- El nombre debe ser exactamente `google-services.json`
