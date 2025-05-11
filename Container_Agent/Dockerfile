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

# Instala Terraform (latest)
RUN TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version) && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

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

# Instala SonarScanner CLI
RUN mkdir -p /opt/sonar-scanner && \
    chmod 777 /usr/local/bin/sonar-scanner \
    curl -sL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip -o sonar-scanner.zip && \
    unzip sonar-scanner.zip -d /opt && \
    mv /opt/sonar-scanner-*/* /opt/sonar-scanner/ && \
    rm -rf sonar-scanner.zip /opt/sonar-scanner-* && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    echo "SonarScanner instalado em:" && \
    which sonar-scanner && \
    sonar-scanner --version
   
# Cria usuário seguro não-root
RUN useradd -m -s /bin/bash jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN useradd -m -d /home/jenkins -s /bin/bash jenkins \
    && mkdir -p /home/jenkins \
    && chown -R jenkins:jenkins /home/jenkins


USER jenkins
WORKDIR /home/jenkins
ENV PATH="/home/jenkins/.local/bin:${PATH}"
