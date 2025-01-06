# Use uma imagem base oficial do Python
FROM python:3.12-slim

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo de requisitos para o diretório de trabalho
COPY requirements.txt .

# Instale as dependências do projeto
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copie o restante do código do projeto para o diretório de trabalho
COPY . .

# Defina as variáveis de ambiente
ARG DJANGO_SECRET_KEY
ARG SERVER_IP
ARG SERVER_PORT
ENV DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
ENV SERVER_IP=${SERVER_IP}
ENV SERVER_PORT=${SERVER_PORT}

# Execute as migrações do Django
RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

# Exponha a porta que o Django usará
EXPOSE ${SERVER_PORT}

# Comando para rodar o servidor Django
CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:$SERVER_PORT"]
