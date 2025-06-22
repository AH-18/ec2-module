# AUTOMATED SONARQUBE SETUP
# These steps are now automated via user_data script in Terraform
# The EC2 instance will automatically run sonarqube_setup.sh on boot

# Manual steps are no longer needed - they are handled automatically:
# ✅ System updates
# ✅ Docker installation and configuration  
# ✅ Docker Compose installation
# ✅ SonarQube + PostgreSQL setup with docker-compose
# ✅ Service startup

# ORIGINAL MANUAL STEPS (for reference):
# Note: ECR steps (#14-19) have been removed - using public Docker images instead

#1 
"sudo apt update"

#2
"sudo apt update -y"

#3 install docker
"sudo apt install docker.io -y"

#4 start docker
"sudo systemctl start docker"

#5 enable docker
"sudo systemctl enable docker"  

#6 add user to docker group
"sudo usermod -aG docker $USER"

#7 refresh group membership
"newgrp docker"

#8 check docker acess
"docker ps"

#9 install cli - REMOVED (not needed for local setup)
# "sudo apt install unzip -y"
# "curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip""
# "unzip awscliv2.zip"
# "sudo ./aws/install"

#10 download command
# "sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose"

#11 make executable
# "sudo chmod +x /usr/local/bin/docker-compose"

#12 make docker file
# "sudo nano docker-compose.yaml"

#13 add content to docker file - NOW AUTOMATED
# Docker compose file is automatically created with this content:

# version: "3"
# services:
#   sonarqube:
#     image: sonarqube:latest
#     container_name: sonarqube
#     ports:
#       - "9000:9000"
#     networks:
#       - sonarnet
#     environment:
#       - SONARQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar
#       - SONARQUBE_JDBC_USERNAME=sonar
#       - SONARQUBE_JDBC_PASSWORD=sonar
#     depends_on:
#       - postgres
#     volumes:
#       - sonarqube_data:/opt/sonarqube/data
#       - sonarqube_logs:/opt/sonarqube/logs
#       - sonarqube_extensions:/opt/sonarqube/extensions
#
#   postgres:
#     image: postgres:latest
#     container_name: postgres
#     environment:
#       - POSTGRES_USER=sonar
#       - POSTGRES_PASSWORD=sonar
#       - POSTGRES_DB=sonar
#     networks:
#       - sonarnet
#     volumes:
#       - postgres_data:/var/lib/postgresql/data
#
# networks:
#   sonarnet:
#     driver: bridge
#
# volumes:
#   postgres_data:
#   sonarqube_data:
#   sonarqube_logs:
#   sonarqube_extensions:

# ECR STEPS REMOVED - Using public Docker images instead:
# #14 login in to ecr - REMOVED
# #15 tag sonerqube image - REMOVED  
# #16 tag postgres image - REMOVED
# #18 push sonerqube image - REMOVED
# #19 push postgres image - REMOVED

# AUTOMATED STEPS:
# #20 run docker compose - AUTOMATED
# "docker-compose up -d"

# #21 to monitor logs - AUTOMATED (helper script created)
# "docker-compose logs -f sonarqube"

# AFTER DEPLOYMENT:
# ✅ SonarQube will be available at: http://YOUR_EC2_PUBLIC_IP:9000
# ✅ Default credentials: admin/admin
# ✅ Use helper scripts on EC2:
#    - /home/ubuntu/sonarqube-status.sh (check status)
#    - /home/ubuntu/sonarqube-logs.sh (view logs)
