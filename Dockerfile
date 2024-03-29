FROM ubuntu

RUN apt update; apt install -y postgresql-client wget unzip jq

RUN wget -q https://releases.hashicorp.com/vault/1.13.1/vault_1.13.1_linux_amd64.zip && \
    unzip vault_1.13.1_linux_amd64.zip && \
    chmod +x vault && \
    mv vault /usr/bin/

COPY configure.sh /usr/bin/configure.sh
COPY service.sh /usr/bin/service.sh
