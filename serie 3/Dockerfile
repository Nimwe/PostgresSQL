# Image Docker sur laquelle est basée la nouvelle image que nous allons créer
FROM postgres:17.2
# Utilisateur "administrateur" du système de gestion de base de données
ENV POSTGRES_USER=postgres
# Mot de passe sécurisé de l'utilisateur user
ENV POSTGRES_PASSWORD=motdepasse
# Création d'une base de données avec un nom prédéfini : "orders"
ENV POSTGRES_DB=orders
# Copie du fichier de création de BDD dans l'image
# ce script sera démarré automatiquement au lancement du conteneur
COPY orders-postgres.sql /docker-entrypoint-initdb.d/