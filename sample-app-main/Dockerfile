# Utilisez une image Docker officielle pour PHP 7.4 avec Apache
FROM php:7.4-apache

# Installez les extensions PHP nécessaires
RUN docker-php-ext-install pdo_mysql

# Installez git, unzip et le client MySQL
RUN apt-get update && apt-get install -y git unzip p7zip-full default-mysql-client

# Installez Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiez les fichiers de l'application dans le conteneur
COPY . /var/www/html/

# Installez les dépendances de l'application
RUN composer install --no-dev --optimize-autoloader

# Définir les permissions pour les répertoires storage et cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Activer le module mod_rewrite d'Apache
RUN a2enmod rewrite

# Copier la configuration personnalisée d'Apache
COPY laravel.conf /etc/apache2/sites-available/laravel.conf

# Activer le nouveau site et désactiver le site par défaut
RUN a2ensite laravel.conf
RUN a2dissite 000-default.conf

# Exposez le port 80
EXPOSE 80

# Copier le script de démarrage dans le conteneur
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Définir le script d'entrée par défaut
CMD ["/entrypoint.sh"]
