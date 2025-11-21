FROM node:18-bullseye

# Install prerequisites
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    unzip \
    curl \
    jq \
    && pip3 install --upgrade pip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

RUN pip3 install localstack
RUN npm install -g aws-cdk aws-cdk-local

# Initialize GIT user
RUN git config --global user.email "stpagda@gmail.com" && \
    git config --global user.name "artem-yanko"

# Default workdir
WORKDIR /workspace