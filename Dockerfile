FROM ubuntu

RUN apt update; apt install -y postgresql-client wget unzip jq

RUN wget -q https://releases.hashicorp.com/vault/1.12.3/vault_1.12.3_linux_amd64.zip && \
    unzip vault_1.12.3_linux_amd64.zip && \
    chmod +x vault && \
    mv vault /usr/bin/

COPY test.sh /usr/bin/test.sh
