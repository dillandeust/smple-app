#!/bin/bash
# Script de démarrage personnalisé pour Azure Web App

echo "Running migrations..."
php artisan migrate --force

echo "Running database seeders..."
php artisan db:seed --force

echo "Starting Laravel app..."
# Démarrer le serveur web (exemple : php artisan serve)
php artisan serve --host=0.0.0.0 --port=8000
