FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="${PATH}:/root/.local/bin"

# Atualiza e instala dependências essenciais
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gnupg \
    sudo \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    php \
    php-cli \
    git \
    openssh-client \
    ca-certificates \
    jq \
    build-essential \
    libffi-dev \
    libssl-dev \
    bash \
    dash \
    coreutils \
    procps \
    docker.io \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    npm install -g npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Instala Terraform (última versão estável)
RUN set -eux; \
    TERRAFORM_VERSION=$(curl -s https://releases.hashicorp.com/terraform/ | grep -oP 'terraform/\K[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n1); \
    echo "Instalando Terraform $TERRAFORM_VERSION"; \
    curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip; \
    unzip terraform.zip; \
    mv terraform /usr/local/bin/terraform; \
    rm terraform.zip

# Instala Helm (latest)
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Instala kubectl (latest stable)
RUN set -eux; \
    KUBECTL_VERSION="$(curl -sSL https://dl.k8s.io/release/stable.txt)"; \
    echo "Instalando kubectl versão $KUBECTL_VERSION"; \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
    chmod +x kubectl; \
    mv kubectl /usr/local/bin/kubectl

# Instala Ansible
RUN pip3 install --upgrade pip && pip3 install ansible

# Instala AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && \
    rm -rf awscliv2.zip aws

# Instala Docker CLI (versão atualizada)
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-25.0.3.tgz | tar xz && \
    mv docker/docker /usr/bin/docker && \
    rm -rf docker

# Instala Sonar Scanner CLI
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip && \
    unzip sonar-scanner-cli-5.0.1.3006-linux.zip && \
    mv sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm sonar-scanner-cli-5.0.1.3006-linux.zip

# Adiciona o repositório oficial do Docker para Debian
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | tee /etc/apt/trusted.gpg.d/docker.asc \
 && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y docker-ce docker-ce-cli containerd.io


# Cria usuário seguro não-root
RUN useradd -m -s /bin/bash jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jenkins
WORKDIR /home/jenkins
ENV PATH="/home/jenkins/.local/bin:${PATH}"
