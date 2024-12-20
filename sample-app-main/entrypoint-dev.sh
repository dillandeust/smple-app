#!/bin/bash

# Attendre que la base de données soit prête
echo "Waiting for the database to be ready..."
until mysqladmin ping -h"$DB_HOST" -u"$DB_USERNAME" -p"$DB_PASSWORD" --silent; do
  sleep 1
done

# Exécuter les migrations et le seed
echo "Running migrations..."
php artisan migrate --force || { echo 'Migration failed' ; exit 1; }
echo "Seeding database..."
php artisan db:seed --force || { echo 'Seeding failed' ; exit 1; }

# Démarrer Apache en premier plan
echo "Starting Apache..."
apache2-foreground
