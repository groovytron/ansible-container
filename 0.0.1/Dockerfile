FROM groovytron/python:3.8

ARG ANSIBLE_VERSION
ARG SOPS_VERSION

USER root

ADD https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb \
    sops.deb

# hadolint ignore=DL3008
RUN apt-get update --quiet \
 && apt-get install --quiet --yes --no-install-recommends \
        gnupg \
        wget \
 && dpkg -i sops.deb \
 && apt-get autoremove --quiet --yes \
 && apt-get clean \
 && rm \
        /var/lib/apt/lists/* \
        rm sops.deb

RUN pip3 install --no-cache-dir \
        ansible==${ANSIBLE_VERSION}

USER dev
