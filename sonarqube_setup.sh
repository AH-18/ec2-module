#!/bin/bash

# SonarQube Automated Setup Script
# This script will install and configure SonarQube with PostgreSQL using Docker

set -e  # Exit on any error

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/sonarqube-setup.log
}

log "Starting SonarQube automated setup..."

# Update system
log "Updating system packages..."
sudo apt update -y

# Install Docker
log "Installing Docker..."
sudo apt install docker.io -y

# Start and enable Docker
log "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
log "Adding ubuntu user to docker group..."
sudo usermod -aG docker ubuntu

# Install Docker Compose
log "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create docker-compose.yaml for SonarQube
log "Creating docker-compose.yaml file..."
cat << 'EOF' > /home/ubuntu/docker-compose.yaml
version: "3"
services:
  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9000:9000"
    networks:
      - sonarnet
    environment:
      - SONARQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=sonar
    depends_on:
      - postgres
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions

  postgres:
    image: postgres:latest
    container_name: postgres
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
      - POSTGRES_DB=sonar
    networks:
      - sonarnet
    volumes:
      - postgres_data:/var/lib/postgresql/data

networks:
  sonarnet:
    driver: bridge

volumes:
  postgres_data:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:
EOF

# Set ownership of docker-compose file
chown ubuntu:ubuntu /home/ubuntu/docker-compose.yaml

# Pull images first to ensure they're available
log "Pulling Docker images..."
sudo docker pull sonarqube:latest
sudo docker pull postgres:latest

# Navigate to the directory and start services
log "Starting SonarQube services..."
cd /home/ubuntu
sudo docker-compose up -d

# Wait a moment for services to start
sleep 30

# Check if services are running
log "Checking service status..."
sudo docker-compose ps

# Create a script to monitor logs
cat << 'EOF' > /home/ubuntu/sonarqube-logs.sh
#!/bin/bash
echo "SonarQube Logs:"
docker-compose logs -f sonarqube
EOF

chmod +x /home/ubuntu/sonarqube-logs.sh
chown ubuntu:ubuntu /home/ubuntu/sonarqube-logs.sh

# Create a script to check service status
cat << 'EOF' > /home/ubuntu/sonarqube-status.sh
#!/bin/bash
echo "=== SonarQube Service Status ==="
docker-compose ps
echo ""
echo "=== Container Health ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "=== SonarQube URL ==="
echo "http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9000"
echo ""
echo "Default credentials: admin/admin"
EOF

chmod +x /home/ubuntu/sonarqube-status.sh
chown ubuntu:ubuntu /home/ubuntu/sonarqube-status.sh

log "SonarQube setup completed successfully!"
log "Access SonarQube at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9000"
log "Default credentials: admin/admin"
log "Use 'sudo /home/ubuntu/sonarqube-logs.sh' to monitor logs"
log "Use 'sudo /home/ubuntu/sonarqube-status.sh' to check status"

# Create completion marker
touch /home/ubuntu/sonarqube-setup-complete
