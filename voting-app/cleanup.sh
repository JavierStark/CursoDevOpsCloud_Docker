#!/bin/bash

# Script para limpiar archivos innecesarios si solo usas docker compose

echo "🗑️  Limpiando archivos innecesarios para docker compose..."

# Kubernetes
rm -rf k8s-specifications/
echo "✓ Eliminado k8s-specifications/"

# GitHub
rm -rf .github/
echo "✓ Eliminado .github/"

# Git (descomenta si quieres borrarlo)
# rm -rf .git/
# echo "✓ Eliminado .git/"

# VSCode
rm -rf .vscode/
echo "✓ Eliminado .vscode/"

# Seed data (descomenta si no lo necesitas)
# rm -rf seed-data/
# echo "✓ Eliminado seed-data/"

# Archivos individuales
rm -f docker-stack.yml
echo "✓ Eliminado docker-stack.yml"

rm -f docker-compose.images.yml
echo "✓ Eliminado docker-compose.images.yml"

rm -f .gitattributes
echo "✓ Eliminado .gitattributes"

rm -f .gitignore
echo "✓ Eliminado .gitignore"

rm -f MAINTAINERS
echo "✓ Eliminado MAINTAINERS"

rm -f LICENSE
echo "✓ Eliminado LICENSE"

rm -f architecture.excalidraw.png
echo "✓ Eliminado architecture.excalidraw.png"

echo ""
echo "✅ Limpieza completada!"
echo ""
echo "📁 Estructura mínima mantenida:"
echo "   - docker-compose.yml"
echo "   - healthchecks/"
echo "   - vote/"
echo "   - result/"
echo "   - worker/"
echo "   - README.md"
echo ""
echo "🚀 Ahora puedes ejecutar: docker compose up"
