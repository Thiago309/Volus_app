# Multi-stage build
FROM debian:latest AS build-env

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y unzip curl git xz-utils zip libglu1-mesa

# Instalar o Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor

# Configurar diretório de trabalho e copiar código
WORKDIR /app
COPY . .

# Compilar a aplicação para Web
RUN flutter build web --release

# Servidor leve Nginx de Produção
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
