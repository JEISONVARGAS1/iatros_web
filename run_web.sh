#!/bin/bash

# Script para ejecutar Flutter Web con configuración SPA
echo "🚀 Iniciando Iatros Web..."

# Limpiar build anterior
echo "🧹 Limpiando build anterior..."
flutter clean

# Obtener dependencias
echo "📦 Obteniendo dependencias..."
flutter pub get

# Ejecutar con configuración para SPA
echo "🌐 Iniciando servidor web..."
flutter run -d web-server --web-port 55171 --web-hostname 0.0.0.0

echo "✅ Servidor iniciado en http://localhost:55171"
