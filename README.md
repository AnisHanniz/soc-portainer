# Security Containers Setup Script

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A comprehensive Bash script for setting up a customized security environment with Docker containers for Firefox, Kali Linux, and Splunk.

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
