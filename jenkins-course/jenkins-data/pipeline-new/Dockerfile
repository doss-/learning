FROM jenkins/jenkins

USER root

# Install Ansible
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py

RUN pip install ansible --upgrade

#USER jenkins

# Install Docker

RUN apt-get update && \
    apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
     apt-key add - && \
    add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable" && \
    apt-get update && \
    apt-get install -y docker-ce

# Install Docker Compose

RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN usermod -aG docker jenkins

USER jenkins
