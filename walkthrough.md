# Guia de Execução: AWS, Terraform, Jenkins & Monitoramento (Prometheus & Grafana)

Todas as configurações de infraestrutura com **Terraform**, **Jenkins**, monitoramento com **Prometheus/Grafana** e a separação de imagens Docker foram implementadas com sucesso no repositório.

---

## 📂 Novas Configurações Criadas

### 1. Separação de Dockerfiles (IaC Cliente vs Aplicação Web)
*   **[Dockerfile](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/volus_app/Dockerfile)**: Configuração do container cliente IaC contendo **Terraform 1.14.4** e **AWS CLI** para provisionamento local seguro.
*   **[Dockerfile.web](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/volus_app/Dockerfile.web)**: Mantém o empacotamento original da aplicação Flutter Web servida pelo Nginx.

### 2. Infraestrutura na AWS (Terraform)
Localizado na pasta `/terraform`:
*   **[variables.tf](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/terraform/variables.tf)**: Parametrização dos inputs (região, chaves, instância).
*   **[main.tf](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/terraform/main.tf)**: Provisiona a VPC, Subnets, Internet Gateway, Security Groups (com portas SSH, HTTP, 8080, 3000 e 9090 liberadas) e uma Instância EC2 (`t3.medium` com disco de 30GB gp3).
*   **[userdata.sh](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/terraform/userdata.sh)**: Automatiza a instalação do Docker, Docker Compose, Git e cria uma partição de memória **Swap de 4GB** no servidor AWS.
*   **[outputs.tf](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/terraform/outputs.tf)**: Exporta as URLs públicas e o IP da instância.

### 3. Orquestração & Monitoramento (Docker Compose)
*   **[nginx.conf](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/volus_app/nginx.conf)**: Ativa o módulo de conexões `/nginx_status`.
*   **[prometheus.yml](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/volus_app/prometheus.yml)**: Define os alvos (targets) de raspagem de métricas.
*   **[docker-compose.yml](file:///c:/Users/karer/OneDrive/Documentos/GitHub/Volus_app/volus_app/docker-compose.yml)**: Agrupa e executa os containers `web` (usando Dockerfile.web), `nginx-exporter` (métricas Nginx), `node-exporter` (métricas da máquina física), `prometheus`, `grafana` e `jenkins`.

---

## 🚀 Como Executar e Testar

### Passo 1: Construir e Iniciar o Container Cliente IaC (Local)

1. Entre no diretório do projeto e construa a imagem do cliente IaC:
   ```bash
   docker build -t volusapp-img:cli-aws-terraform ./volus_app
   ```
2. Inicialize o container mapeando sua pasta de trabalho e entre no terminal dele:
   - **No Linux/WSL 2**:
     ```bash
     docker run -dit --name cli-aws-terraform -v ./volus_app:/volus_app volusapp-img:cli-aws-terraform /bin/bash
     ```
   - **No Windows (PowerShell)**:
     ```powershell
     docker run -dit --name cli-aws-terraform -v ${PWD}/volus_app:/volus_app volusapp-img:cli-aws-terraform /bin/bash
     ```

### Passo 2: Configurar e Rodar o Terraform (Dentro do Container Cliente)

1. Acesse o terminal interativo do container recém-criado:
   ```bash
   docker exec -it cli-aws-terraform /bin/bash
   ```
2. Configure suas credenciais da AWS:
   ```bash
   aws configure
   ```
3. Acesse a pasta do terraform, inicialize e aplique o plano para subir o servidor EC2 na AWS:
   ```bash
   cd /volus_app/terraform
   terraform init
   terraform plan
   terraform apply
   ```

### Passo 3: Inicializar a Stack no Servidor AWS

1. Uma vez provisionada a máquina, o Terraform retornará o IP público do servidor no terminal. Conecte-se a ele via SSH.
2. Clone o repositório do projeto no servidor e execute a stack:
   ```bash
   cd volus_app/volus_app
   docker compose up -d
   ```
3. Acesse as interfaces no seu navegador:
   - **App Web**: `http://<IP-EC2>`
   - **Jenkins**: `http://<IP-EC2>:8080`
   - **Grafana**: `http://<IP-EC2>:3000` (User default: `admin`/`admin`)
   - **Prometheus**: `http://<IP-EC2>:9090`
