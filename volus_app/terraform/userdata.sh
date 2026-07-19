#!/bin/bash
# Log execution
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Iniciando User Data ==="

# Atualizar pacotes
apt-get update -y
apt-get upgrade -y

# Instalar pacotes necessários
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release git unzip

# Adicionar repositório oficial do Docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Iniciar e habilitar o Docker
systemctl start docker
systemctl enable docker

# Configurar permissões para o usuário padrão ubuntu
usermod -aG docker ubuntu

# Instalar o Docker Compose v2 standalone
curl -SL https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Criar Swap File de 4GB para evitar estouro de memória física pelo Jenkins/Grafana
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# Baixar o repositório e iniciar a stack Docker Compose automaticamente
cd /home/ubuntu
git clone https://github.com/Thiago309/Volus_app.git
chown -R ubuntu:ubuntu /home/ubuntu/Volus_app

# Executar a stack como o usuário ubuntu
cd /home/ubuntu/Volus_app/volus_app
sudo -u ubuntu docker compose up -d

echo "=== User Data Concluído ==="
