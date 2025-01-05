#!/bin/bash
# Script de démarrage personnalisé pour Azure Web App

echo "Clearing and caching config..."
php artisan config:clear
php artisan config:cache

echo "Running migrations..."
php artisan migrate --force

echo "Running database seeders..."
php artisan db:seed --force

echo "Starting Laravel app..."
# Démarrer le serveur web (exemple : php artisan serve)
php artisan serve 
