# Iatros Web

Una aplicación web de Flutter con arquitectura modular, escalable y reutilizable usando Supabase como backend y Riverpod para el manejo de estado.

## 🏗️ Arquitectura del Proyecto

El proyecto sigue una arquitectura de capas bien definida:

```
lib/
├── core/                    # Funcionalidades base del proyecto
│   ├── api/                # Clase base para comunicación HTTP
│   ├── models/             # Modelos base (QueryResponseModel)
│   └── util/               # Utilidades y servicios base
├── features/               # Funcionalidades por módulos
│   ├── auth/               # Módulo de autenticación
│   │   ├── data/           # APIs e interfaces
│   │   ├── models/         # Modelos específicos del módulo
│   │   ├── provider/       # Controladores y estados con Riverpod
│   │   ├── repository/     # Lógica de negocio y control de errores
│   │   └── presentation/   # Vistas y widgets de UI
│   └── home/               # Módulo de inicio
├── uikit/                  # Sistema de diseño reutilizable
│   ├── components/         # Componentes UI (botones, inputs, cards)
│   ├── theme/              # Colores, tipografía, espaciado
│   └── utils/              # Utilidades de UI
└── main.dart              # Punto de entrada de la aplicación
```

## 🚀 Tecnologías Utilizadas

- **Frontend:** Flutter Web
- **Backend:** Supabase
- **Estado:** Riverpod
- **Modelado:** Freezed
- **HTTP:** http package
- **UI:** Material Design 3

## 📋 Configuración Inicial

### 1. Configurar Supabase

1. Crea un proyecto en [Supabase](https://supabase.com)
2. Obtén tu URL y clave anónima del proyecto
3. Actualiza las siguientes variables en el código:

**En `lib/main.dart`:**
```dart
await Supabase.initialize(
  url: 'https://tu-proyecto.supabase.co', // Tu URL de Supabase
  anonKey: 'tu-clave-anonima', // Tu clave anónima
);
```

**En `lib/core/util/service/server.dart`:**
```dart
static const String _baseUrl = 'https://tu-proyecto.supabase.co';
static const String _apiKey = 'tu-clave-anonima';
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Generar Código

```bash
flutter packages pub run build_runner build
```

### 4. Ejecutar la Aplicación

```bash
flutter run -d chrome
```

## 🎨 Sistema de Diseño (UIKit)

El proyecto incluye un sistema de diseño completo y reutilizable:

### Componentes Disponibles

- **Botones:** `PrimaryButton`, `SecondaryButton`, `AppIconButton`
- **Inputs:** `TextInput`, `PasswordInput`, `SpecializationSelector`, `ImagePickerInput`
- **Cards:** `BaseCard`
- **Logo:** `IatrosLogo`, `IatrosLogoVertical`, `IatrosLogoIcon`
- **Fondos:** `SimpleMedicalBackground`, `MedicalBackground`
- **Utilidades:** `UIHelpers` (espaciado, dividers, loading, etc.)

### Tema

- **Colores:** Paleta completa con colores primarios, secundarios y neutros
- **Tipografía:** Sistema tipográfico consistente
- **Espaciado:** Sistema de espaciado estandarizado

### Uso del UIKit

```dart
import 'package:iatros_web/uikit/index.dart';

// Usar componentes
PrimaryButton(
  label: 'Mi Botón',
  onPressed: () {},
)

// Usar logo
IatrosLogoVertical(
  width: 100,
  height: 100,
  textColor: AppColors.primary,
)

// Usar fondo médico
SimpleMedicalBackground(
  child: YourContent(),
)

// Usar espaciado
UIHelpers.verticalSpaceMD

// Usar colores
AppColors.primary
```

## 🔐 Autenticación Médica

El módulo de autenticación está diseñado específicamente para médicos e incluye:

- **Login** con email y contraseña
- **Registro médico completo** con:
  - Información personal (nombre, apellido, teléfono)
  - Información médica (licencia, especialización, años de experiencia)
  - Documentación (foto de tarjeta profesional)
  - Biografía profesional
- **20+ especializaciones médicas** predefinidas
- **Selección de imagen** desde galería o cámara
- **Validación completa** de formularios
- **Logout** y manejo de sesión
- **Estado persistente** con Riverpod

### Flujo de Autenticación

1. La aplicación verifica automáticamente el estado de autenticación
2. Si no está autenticado, muestra la página de login
3. Si está autenticado, muestra el dashboard principal
4. El estado se mantiene durante toda la sesión

## 📱 Funcionalidades Implementadas

- ✅ Sistema de autenticación médico completo
- ✅ Registro con 20+ especializaciones médicas
- ✅ Carga de foto de tarjeta profesional
- ✅ Validación completa de formularios médicos
- ✅ Navegación entre páginas
- ✅ Manejo de estado con Riverpod
- ✅ Sistema de diseño reutilizable
- ✅ Manejo de errores
- ✅ Loading states
- ✅ Responsive design
- ✅ Logo de IATROS integrado
- ✅ Fondo médico personalizado

## 🔧 Estructura de Archivos por Módulo

Cada módulo sigue la misma estructura:

```
feature_name/
├── data/
│   ├── feature_api_interface.dart    # Interfaz abstracta
│   └── feature_api.dart              # Implementación
├── models/
│   └── feature_model.dart            # Modelos con Freezed
├── provider/
│   ├── model/
│   │   └── feature_state.dart        # Estado con Freezed
│   └── feature_controller.dart       # Controlador con Riverpod
├── repository/
│   └── feature_repository.dart       # Lógica de negocio
└── presentation/
    └── pages/
        └── feature_page.dart         # Vistas
```

## 🚀 Próximos Pasos

1. **Configurar Supabase** con tus credenciales
2. **Personalizar el tema** según tus necesidades
3. **Agregar nuevas funcionalidades** siguiendo la arquitectura establecida
4. **Implementar tests** para cada capa
5. **Configurar CI/CD** para despliegue automático

## 📚 Recursos Adicionales

- [Documentación de Flutter](https://flutter.dev/docs)
- [Documentación de Supabase](https://supabase.com/docs)
- [Documentación de Riverpod](https://riverpod.dev/docs)
- [Documentación de Freezed](https://pub.dev/packages/freezed)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
