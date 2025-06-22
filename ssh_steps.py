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

#9 install cli
"sudo apt install unzip -y"
"curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip""
"unzip awscliv2.zip"
"sudo ./aws/install"

#10 download command
"sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose"

#11 make executable
"sudo chmod +x /usr/local/bin/docker-compose"

#12 make docker file
"sudo nano docker-compose.yaml"

#13 add content to docker file

# "version: "3"
# services:
#   sonarqube:
#     image: sonarqube:latest
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

#   postgres:
#     image: postgres:latest
#     environment:
#       - POSTGRES_USER=sonar
#       - POSTGRES_PASSWORD=sonar
#       - POSTGRES_DB=sonar
#     networks:
#       - sonarnet
#     volumes:
#       - postgres_data:/var/lib/postgresql/data

# networks:
#   sonarnet:

# volumes:
#   postgres_data:"


#14 login in to ecr
"aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 619071337720.dkr.ecr.us-east-1.amazonaws.com"

#15 tag sonerqube image
"docker tag sonarqube:latest 619071337720.dkr.ecr.us-east-1.amazonaws.com/sonerqube-server-ecr-dev:sonarqube"

#16 tag postgres image
"docker tag postgres:latest 619071337720.dkr.ecr.us-east-1.amazonaws.com/sonerqube-server-ecr-dev:postgres"

#18 push sonerqube image
"docker push 619071337720.dkr.ecr.us-east-1.amazonaws.com/sonerqube-server-ecr-dev:sonarqube"
# if there is an error with no such image exists, pull image first
"docker pull sonarqube:latest" #then tag and push

#19 push postgres image
"docker push 619071337720.dkr.ecr.us-east-1.amazonaws.com/sonerqube-server-ecr-dev:postgres"

#20 run docker compose
"docker-compose up -d"

#21 to monitor logs
"docker-compose logs -f sonarqube"
