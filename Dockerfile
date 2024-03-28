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
COPY wait.sh /wait.sh
RUN chmod +x /wait.sh

# Provide 777 permission to /opt directory
RUN chmod 777 /opt/ -R

# Create an 'ubuntu' user with sudo privileges
RUN useradd -m -s /bin/bash ubuntu && echo "ubuntu:ubuntu" | chpasswd

# Switch to ubuntu user
USER ubuntu

# Set shell to bash
SHELL ["/bin/bash", "-c"]

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

# Add environment variables for Go to .bashrc file
RUN echo 'export GOROOT=/opt/software/go19' >> /home/ubuntu/.bashrc \
    && echo 'export GOPATH=/opt/software/go19/gopath' >> /home/ubuntu/.bashrc \
    && echo 'export PATH=$PATH:/opt/software/go19/bin' >> /home/ubuntu/.bashrc

# Install nvm (node version manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && /bin/bash -c "source /home/ubuntu/.nvm/nvm.sh && nvm install v16.17.0 && npm install -g yarn"

# Set the default command to execute the script
CMD ["/wait.sh"]
