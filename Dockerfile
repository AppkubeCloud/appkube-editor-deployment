# Create image based on Ubuntu 22.04
FROM ubuntu:22.04

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Update and install necessary packages
RUN apt update && apt upgrade -y \
&& apt install -y sudo curl wget zip unzip build-essential git

# Set root user
USER root

# Add a script to wait for 5 minutes before exiting
# COPY wait.sh /wait.sh
# RUN chmod +x /wait.sh

# Provide 777 permission to /opt directory
RUN chmod 777 /opt/ -R

# # Create an 'ubuntu' user with sudo privileges
# RUN useradd -m -s /bin/bash ubuntu && echo "ubuntu:ubuntu" | chpasswd

# # Switch to ubuntu user
# USER ubuntu

# # Set shell to bash
# SHELL ["/bin/bash", "-c"]

# Create directory for software
RUN mkdir -p /opt/software

# Go to /opt/software
WORKDIR /opt/software

# Download Go version 1.19
RUN wget https://golang.org/dl/go1.19.1.linux-amd64.tar.gz

# Untar downloaded tar file
RUN tar -xf go1.19.1.linux-amd64.tar.gz

# Rename the go directory to go19
RUN mv go go19

# Create GOPATH folder inside Go
RUN mkdir -p /opt/software/go19/gopath

# Set environment variables for Go
ENV GOROOT=/opt/software/go19
ENV GOPATH=/opt/software/go19/gopath
ENV PATH=$PATH:/opt/software/go19/bin

# Install nvm (node version manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
&& /bin/bash -c "source /root/.nvm/nvm.sh && nvm install v16.17.0 && npm install -g yarn"
ENV NVM_DIR "/root/.nvm"
# Load nvm and bash completion
RUN /bin/bash -c "[ -s \"$NVM_DIR/nvm.sh\" ] && . \"$NVM_DIR/nvm.sh\" && [ -s \"$NVM_DIR/bash_completion\" ] && . \"$NVM_DIR/bash_completion\""
# Create directory for code
# RUN mkdir -p /opt/mycode

# # Clone repository
# WORKDIR /opt/mycode
# RUN git clone https://github.com/AppkubeCloud/Appkube-editor.git

# Go to cloned directory
# WORKDIR /opt/mycode/Appkube-editor

# # Install wire - keep it in base
RUN go install github.com/google/wire/cmd/wire@latest

# # Generate wire files - build
# RUN $(go env GOPATH)/bin/wire gen -tags oss ./pkg/server/ ./pkg/cmd/grafana-cli/runner

# # Install yarn and run yarn install --immutable , keep in base
RUN /bin/bash -c "source /root/nvm/nvm.sh && yarn install --immutable"

RUN sleep 600

# Set the default command to execute the script
# CMD ["/wait.sh"]
