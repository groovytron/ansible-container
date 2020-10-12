FROM groovytron/python:3.8

ARG ANSIBLE_VERSION
ARG SOPS_VERSION

USER root

RUN apt-get update --quiet \
    && apt-get upgrade --quiet --yes \
    && apt-get install --quiet --yes \
        gnupg \
        wget

RUN wget https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb

RUN dpkg -i sops_${SOPS_VERSION}_amd64.deb

RUN apt-get autoremove --quiet --yes \
    && apt-get clean

RUN pip install ansible==${ANSIBLE_VERSION}

USER dev
