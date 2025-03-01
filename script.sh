#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonction pour afficher les messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Vérification si l'utilisateur est root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "Ce script doit être exécuté en tant que root"
        exit 1
    fi
}

# Vérification des dépendances système
check_dependencies() {
    local deps=("curl" "wget" "netstat" "docker" "docker-compose")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            error "Dépendance manquante : $dep"
            log "Installation des dépendances manquantes..."
            apt-get update && apt-get install -y "$dep"
        fi
    done
}

# Vérification de Docker et Docker Compose
check_docker() {
    if ! systemctl is-active --quiet docker; then
        error "Docker n'est pas en cours d'exécution"
        log "Démarrage de Docker..."
        systemctl start docker
    fi
}

# Vérification des ports utilisés
check_ports() {
    local ports=(3000 3001 8001 8444)
    for port in "${ports[@]}"; do
        if netstat -tuln | grep -q ":$port "; then
            warn "Le port $port est déjà utilisé, cela pourrait causer des conflits"
        fi
    done
}

# Arrêt des conteneurs existants qui pourraient causer des conflits
stop_existing_containers() {
    log "Vérification des conteneurs existants qui pourraient causer des conflits"
    
    # Arrêt de tous les conteneurs qui utilisent les ports spécifiques
    for port in 3000 3001 8001 8444; do
        local containers_on_port=$(docker ps -q --filter publish=$port)
        if [ ! -z "$containers_on_port" ]; then
            warn "Des conteneurs utilisant le port $port sont en cours d'exécution. Arrêt en cours..."
            docker stop $containers_on_port
        fi
    done
}

# Création de l'utilisateur secuser
create_user() {
    if ! id "secuser" &>/dev/null; then
        log "Création de l'utilisateur secuser"
        useradd -u 1001 -m secuser
        usermod -aG docker secuser
    fi
}

# Sauvegarde des configurations existantes
backup_config() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="/opt/security/backup_$timestamp"
    
    if [ -d "/opt/security" ]; then
        log "Création d'une sauvegarde dans $backup_dir"
        mkdir -p "$backup_dir"
        cp -r /opt/security/* "$backup_dir" 2>/dev/null || true
    fi
}

# Configuration des répertoires
setup_directories() {
    local base_dir="/opt/security"
    local services=("firefox" "kali" "splunk")
    
    log "Création et configuration des répertoires"
    mkdir -p "$base_dir"
    
    for service in "${services[@]}"; do
        log "Configuration des répertoires pour $service"
        mkdir -p "$base_dir/$service/config"
        mkdir -p "$base_dir/$service/data"
        
        chown -R secuser:secuser "$base_dir/$service"
        chmod -R 755 "$base_dir/$service"
    done
}

# Vérification de l'espace disque
check_disk_space() {
    local required_space=20 # Go
    local available_space=$(df -BG /opt | awk 'NR==2 {print $4}' | sed 's/G//')
    
    if [ "$available_space" -lt "$required_space" ]; then
        warn "Espace disque disponible ($available_space Go) inférieur à la recommandation ($required_space Go)"
    fi
}

# Pull des images Docker
pull_images() {
    log "Téléchargement de l'image Firefox..."
    docker pull lscr.io/linuxserver/firefox:latest
    
    log "Téléchargement de l'image Kali Linux..."
    docker pull lscr.io/linuxserver/kali-linux:latest
    
    log "Téléchargement de l'image Splunk..."
    docker pull splunk/splunk:latest
}

# Création du fichier docker-compose.yml
create_docker_compose() {
    log "Création du fichier docker-compose.yml"
    cat > docker-compose.yml << 'EOF'
version: '3'
services:
  firefox:
    image: lscr.io/linuxserver/firefox:latest
    container_name: firefox
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/Paris
      - PASSWORD=securefox
    volumes:
      - /opt/security/firefox/config:/config
    ports:
      - "3000:3000"
    restart: unless-stopped
    shm_size: 1gb

  kali:
    image: lscr.io/linuxserver/kali-linux:latest
    container_name: kali
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/Paris
      - PASSWORD=kalipass
    volumes:
      - /opt/security/kali/config:/config
    ports:
      - "3001:3000"
    restart: unless-stopped
    shm_size: 1gb

  splunk:
    image: splunk/splunk:latest
    container_name: splunk
    environment:
      - SPLUNK_START_ARGS=--accept-license
      - SPLUNK_PASSWORD=secSplunkP@ss
    volumes:
      - /opt/security/splunk/config:/opt/splunk/etc
      - /opt/security/splunk/data:/opt/splunk/var
    ports:
      - "8001:8000"
      - "8444:8443"
    restart: unless-stopped
EOF
}

# Validation de la configuration Docker Compose
validate_config() {
    log "Validation de la configuration Docker Compose"
    if ! docker-compose config > /dev/null; then
        error "Configuration docker-compose invalide"
        exit 1
    fi
}

# Démarrage des conteneurs
start_containers() {
    log "Arrêt des conteneurs existants"
    docker-compose down --remove-orphans
    
    log "Démarrage des nouveaux conteneurs"
    docker-compose up -d
    
    log "Vérification de l'état des conteneurs"
    sleep 10
    docker-compose ps
}

# Affichage des informations finales
show_final_info() {
    info "Installation terminée. Accédez aux services via:"
    echo -e "${BLUE}Firefox:${NC} http://localhost:3000 (password: securefox)"
    echo -e "${BLUE}Kali Linux:${NC} http://localhost:3001 (password: kalipass)"
    echo -e "${BLUE}Splunk:${NC} http://localhost:8001 (credentials: admin/secSplunkP@ss)"
    echo -e "\n${YELLOW}Note:${NC} Lors de la première connexion, il peut y avoir un léger délai pour que tous les services soient complètement initialisés."
    echo -e "${YELLOW}Note:${NC} Pour des raisons de sécurité, changez les mots de passe par défaut après la première connexion."
    echo -e "${YELLOW}Note:${NC} Portainer continuera à fonctionner normalement sur ses ports par défaut."
}

# Fonction principale
main() {
    log "Démarrage de l'installation des conteneurs de sécurité"
    
    check_root
    check_dependencies
    check_docker
    check_ports
    stop_existing_containers
    create_user
    backup_config
    setup_directories
    check_disk_space
    pull_images
    create_docker_compose
    validate_config
    start_containers
    show_final_info
    
    log "Installation terminée avec succès"
}

# Exécution du script
main
