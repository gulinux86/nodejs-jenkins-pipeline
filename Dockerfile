# Usa imagem base oficial do Node.js
FROM node:18

# Cria diretório de trabalho
WORKDIR /app

# Copia package.json e instala dependências
COPY package*.json ./
RUN npm install

# Copia o restante do código da aplicação
COPY . .

# Define a porta que o container vai expor
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
