# Voluts TETO 🏠💙

O **Voluts TETO** é um aplicativo web/mobile desenvolvido para a **Fundação TETO Brasil**, com o objetivo de conectar, engajar e gerenciar voluntários nas suas frentes de atuação comunitária (construções, pesquisas de campo, reuniões de alocação e captação de recursos). 

A plataforma possui duas jornadas completas de uso: a do **Voluntário**, focada em engajamento, visualização de escalas e impacto; e a do **Administrador**, voltada para coordenação, aprovação de depoimentos, gerenciamento de status de escalas e controle de usuários.

---

## 📸 Demonstração das Telas & Funcionalidades

### 👥 Jornada do Voluntário
1. **Login & Seleção de Perfil**: Tela de login limpa com a logo oficial da TETO (desenhada via `CustomPainter`), suporte a recuperação de senha e um seletor visual (*Segmented Control*) para escolher entrar como Voluntário ou Administrador.
2. **Menu Lateral (Drawer)**: Hambúrguer contendo 10 atalhos estruturados direcionando de forma nativa e segura para portais institucionais oficiais da TETO (Sobre a TETO, Transparência, Como doar, Ouvidoria, etc.).
3. **Início (Home)**: Card de alertas meteorológicos descartável, métricas de impacto financeiro/arrecadação, carrossel de projetos ativos e galeria de fotos.
4. **Projetos Ativos**: Listagem completa de projetos com filtros rápidos por status (*Em andamento*, *Planejamento*, *Captação de Recursos*). Contém botão de redirecionamento dinâmico para a aba de escala.
5. **Galeria Recente**: Feed vertical de fotos de ações em andamento com suporte a carregamento sob demanda ("Carregar Mais").
6. **Agenda**: Resumo de horas doadas, carrossel com fotos/status ativo da equipe de campo e visualização detalhada de cronograma futuro.
7. **Confirmar Escala**: Card interativo para confirmar presença ("Vou comparecer" com feedback visual verde) ou recusar ("Não poderei comparecer" com feedback vermelho), atualizando instantaneamente a interface para um estado vazio customizado.
8. **Perfil do Voluntário**: Dados cadastrais, status verificado do termo de voluntariado e gerenciamento interativo de disponibilidade via chaves (*Switches*) e chips de justificativas desabilitáveis.

### 👑 Jornada do Administrador
1. **Painel Geral (Home)**: Atalhos rápidos para cadastrar novos projetos e postar avisos, métricas de famílias assistidas com edição direta, progresso financeiro da campanha, moderação de depoimentos de voluntários (aprovar/rejeitar dinamicamente com animação de sumiço) e tabela consolidada de projetos.
2. **Gerenciar Escalas**: Painel completo para automatizar escalas, notificar voluntários e visualizar a escala ativa dividida por cores de status (*Confirmado*, *Presente*, *Troca Solicitada*, *Indisponível*). Tocar em um voluntário abre uma aba inferior (*BottomSheet*) para alterar seu status dinamicamente.
3. **Gerenciar Usuários**: Busca textual de voluntários cadastrados e grade interativa com acesso à ficha técnica de dados pessoais e contatos de emergência de cada voluntário.

---

## 🎨 Identidade Visual (Design System)

A paleta de cores e tipografia foi desenvolvida com alta fidelidade seguindo o manual da TETO:
* **Azul Marinho (`#082366`)**: Botões principais, cabeçalhos, painéis do administrador e logo oficial.
* **Verde Oliva (`#3F7202`)**: Destaques de sucesso, confirmação de presença, termos ativos de voluntariado e CTAs de incentivo.
* **Fundo Lilás Claro (`#F1EFFB`)**: Botões inferiores e planos de fundo de rodapés.
* **Tipografia**: Fonte **Inter** importada via `google_fonts` para garantir legibilidade técnica moderna.

---

## 🛠️ Tecnologias Utilizadas

* **Framework**: Flutter (Dart) - compilado para **Web**
* **Servidor Web**: Nginx (Alpine) rodando em containers Docker
* **Infraestrutura Cloud**: AWS (EC2) / Vercel (Edge Network)
* **Orquestração**: Docker Compose
* **Qualidade**: Suíte completa de testes unitários e de integração de widgets

---

## 🚀 Como Executar Localmente

### Pré-requisitos
* Flutter SDK (Versão 3.19+ recomendada)
* Google Chrome ou navegador compatível para desenvolvimento web

### Passo a Passo

1. **Clonar o Repositório:**
   ```bash
   git clone https://github.com/Thiago309/Volus_app.git
   cd Volus_app/volus_app
   ```

2. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```

3. **Rodar a aplicação na Web:**
   ```bash
   flutter run -d chrome
   ```

4. **Rodar os Testes Automatizados:**
   ```bash
   flutter test
   ```

---

## 📦 Guia de Deploy (Produção)

### ⚡ Opção A: Deploy no Vercel (Hospedagem Estática)

O Vercel serve a build compilada do Flutter de forma estática com alta performance de cache global.

1. **Compilar os arquivos:**
   ```bash
   flutter build web --release
   ```
2. **Regras de Rota SPA (`vercel.json`):**
   Garante que caminhos internos (ex: `/escala`, `/perfil`) não causem erro 404 ao atualizar a página. Crie em `build/web/vercel.json`:
   ```json
   {
     "cleanUrls": true,
     "rewrites": [
       { "source": "/(.*)", "destination": "/index.html" }
     ]
   }
   ```
3. **Enviar para Vercel via CLI:**
   ```bash
   cd build/web
   npm install -g vercel
   vercel login
   vercel --prod
   ```

---

### 🐳 Opção B: Deploy na AWS EC2 (Docker & Docker Compose)

Hospedagem robusta baseada em containers que compila e serve o projeto utilizando Nginx dentro da nuvem AWS.

#### ⚠️ IMPORTANTE: Ajuste de Memória RAM (SWAP)
O compilador do Flutter Web exige pelo menos **1.5 GB de RAM**. Se estiver em uma instância EC2 gratuita (`t2.micro`/`t3.micro` de 1GB/2GB), configure **2 GB de memória Swap** antes de buildar para evitar que a máquina congele:
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

#### Executar o Deploy com Docker
Na pasta raiz do projeto na instância EC2 (`/home/ubuntu/Volus_app/volus_app`), execute:

1. **Construir e Iniciar os Containers:**
   ```bash
   sudo docker-compose up -d --build
   ```
   *O Docker executará o build multi-stage, instalando o Flutter interno, gerando a release e servindo no Nginx Alpine exposto na porta 80.*

2. **Verificar o Status:**
   ```bash
   sudo docker ps
   ```

3. **Liberar Portas no Painel AWS:**
   No console do EC2, certifique-se de adicionar uma regra de entrada (**Inbound Rule**) liberando tráfego **HTTP (Porta 80)** de qualquer lugar (`0.0.0.0/0`) no Grupo de Segurança (Security Group) associado à sua instância.
