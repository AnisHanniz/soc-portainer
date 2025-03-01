# FR
# Script d'Installation de Conteneurs de Sécurité

[![Licence](https://img.shields.io/badge/Licence-MIT-blue.svg)](LICENSE)

Un script Bash complet pour la mise en place d'un environnement de sécurité personnalisé avec des conteneurs Docker pour Firefox, Kali Linux et Splunk.

## Aperçu

Ce script automatise le déploiement d'un environnement conteneurisé axé sur la sécurité. Il installe et configure :

- Un conteneur Firefox pour une navigation sécurisée
- Un conteneur Kali Linux pour les tests de pénétration et l'évaluation de la sécurité
- Un conteneur Splunk pour l'analyse des logs et la surveillance

Le script gère les dépendances, la création d'utilisateurs, la configuration des répertoires et la configuration appropriée des conteneurs.

## Cas d'Utilisation Personnel

J'utilise personnellement cette configuration sur Portainer qui s'exécute sur mon hyperviseur Proxmox. Ce projet me permet de tester des machines vulnérables et de les surveiller dans un environnement contrôlé. C'est particulièrement utile pour la recherche en sécurité, la pratique des tests de pénétration et l'apprentissage des capacités SIEM avec Splunk, tout en gardant tout conteneurisé et isolé de mes systèmes principaux.

## Fonctionnalités

- **Configuration Automatisée de l'Environnement** : Installation complète avec une seule commande
- **Gestion des Erreurs** : Messages d'erreur et logs colorés
- **Vérifications de Sécurité** : Validation des ports, des fichiers de configuration, et plus encore
- **Sauvegarde de Configuration** : Sauvegarde automatique des configurations existantes
- **Validation des Ressources** : Vérification des dépendances, de l'espace disque et de l'état de Docker

## Prérequis

- Système Linux basé sur Debian (Ubuntu, Debian, etc.)
- Accès root
- Connexion Internet pour télécharger les images Docker

Le script installera automatiquement les dépendances manquantes :
- Docker et Docker Compose
- curl, wget, netstat

## Installation

1. Clonez le dépôt :
```bash
git clone https://github.com/AnisHanniz/conteneurs-securite.git
cd conteneurs-securite
```

2. Rendez le script exécutable :
```bash
chmod +x script.sh
```

3. Exécutez le script en tant que root :
```bash
sudo ./script.sh
```

## Accès aux Services

Après l'installation, vous pouvez accéder aux services à :

| Service | URL | Identifiants par défaut |
|---------|-----|-------------------------|
| Firefox | http://localhost:3000 | Mot de passe : securefox |
| Kali Linux | http://localhost:3001 | Mot de passe : kalipass |
| Splunk | http://localhost:8001 | Nom d'utilisateur : admin<br>Mot de passe : secSplunkP@ss |

## Structure des Répertoires

Le script met en place la structure de répertoires suivante :

```
/opt/security/
├── firefox/
│   ├── config/
│   └── data/
├── kali/
│   ├── config/
│   └── data/
└── splunk/
    ├── config/
    └── data/
```

## Considérations de Sécurité

- Le script crée un utilisateur dédié `secuser` pour exécuter les conteneurs
- Les mots de passe par défaut sont définis dans le fichier docker-compose - changez-les après la première connexion
- Des sauvegardes des configurations existantes sont créées automatiquement

## Dépannage

- Vérifiez l'état des conteneurs Docker : `docker-compose ps`
- Consultez les logs des conteneurs : `docker-compose logs [nom-service]`
- Assurez-vous que tous les ports requis (3000, 3001, 8001, 8444) sont disponibles
- Vérifiez que le service Docker est en cours d'exécution : `systemctl status docker`

## Licence

Ce projet est sous licence MIT - voir le fichier LICENSE pour plus de détails.

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à soumettre une Pull Request.


# ENG
# Security Containers Setup Script

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A comprehensive Bash script for setting up a customized security environment with Docker containers for Firefox, Kali Linux, and Splunk.

## Overview
This script automates the deployment of a security-focused containerized environment. It installs and configures:

-Firefox container for secure browsing
-Kali Linux container for penetration testing and security assessment
-Splunk container for log analysis and monitoring
-The script handles dependencies, user creation, directory setup, and proper container configuration.

## Personal Use Case

I personally use this setup on Portainer which runs on my Proxmox hypervisor. This project allows me to test vulnerable machines and monitor them in a controlled environment. It's particularly useful for security research, penetration testing practice, and learning SIEM capabilities with Splunk, all while keeping everything containerized and isolated from my main systems.

## Features

- **Automated Environment Setup**: Complete setup with a single command
- **Proper Error Handling**: Color-coded logs and error messages
- **Security Checks**: Validation of ports, config files, and more
- **Configuration Backup**: Automatic backup of existing configurations
- **Resource Validation**: Checks for dependencies, disk space and Docker status

## Prerequisites

- Debian-based Linux system (Ubuntu, Debian, etc.)
- Root access
- Internet connection for downloading Docker images

The script will automatically install missing dependencies:
- Docker and Docker Compose
- curl, wget, netstat

## Installation

1. Clone the repository:
```bash
git clone https://github.com/AnisHanniz/security-containers.git
cd security-containers
```

2. Make the script executable:
```bash
chmod +x script.sh
```

3. Run the script as root:
```bash
sudo ./script.sh
```

## Service Access

After installation, you can access the services at:

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| Firefox | http://localhost:3000 | Password: securefox |
| Kali Linux | http://localhost:3001 | Password: kalipass |
| Splunk | http://localhost:8001 | Username: admin<br>Password: secSplunkP@ss |

## Directory Structure

The script sets up the following directory structure:

```
/opt/security/
├── firefox/
│   ├── config/
│   └── data/
├── kali/
│   ├── config/
│   └── data/
└── splunk/
    ├── config/
    └── data/
```

## Security Considerations

- The script creates a dedicated user `secuser` for running containers
- Default passwords are set in the docker-compose file - change them after first login
- Backups of existing configurations are created automatically

## Troubleshooting

- Check the Docker container status: `docker-compose ps`
- View container logs: `docker-compose logs [service-name]`
- Ensure all required ports (3000, 3001, 8001, 8444) are available
- Verify that Docker service is running: `systemctl status docker`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
