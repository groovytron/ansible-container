# Deployer Container

Docker container allowing you to run [Ansible](https://www.ansible.com/) on machines to configure them for your project. It can also be used to run [Ansistrano](https://ansistrano.com/) to deploy your project somewhere.

This container targets deployment from GitLab CI but you can also use it by using docker's CLI. You will need to do the following in the container to make it work:

## Supported tags and respective `Dockerfile` links

- `0.0.1`, `latest` ([0.0.1/Dockerfile](https://github.com/groovytron/deployer-container/blob/master/0.0.1/Dockerfile))

The following softwares are installed:

- [ansible](https://www.ansible.com/) for configuration management
- `gpg` and [sops](https://github.com/mozilla/sops) for YAML secrets decryption
- `openssh` for ssh connection and key forwarding

## Use the container

- start the ssh agent to make ssh agent key forwarding possible
- put your ssh key inside the container to be able to access the target machines
- setup your things according to your project (eg. decrypt secrets using `sops`, etc.)
- run ansible/ansistrano

Here is an example of GitLab CI configuration. **This configuration should be considered more as an inspiration than a guideline and example of best practice**:

```yaml
stages:
  - deploy

variables:
  ANSIBLE_HOST_KEY_CHECKING: 'False'

deploy:dev-bar:
  stage: deploy
  when: manual
  environment:
    name: production-server
  image: groovytron/deployer:latest
  script:
    - eval $(ssh-agent -s)
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - mv $PROVISIONNER_SSH_KEY ~/.ssh/id_rsa
    - chmod 600 ~/.ssh/id_rsa
    - cd ansistrano # got into Ansistrano configuration folder
    - make install # basically install roles
    - ansible-playbook -i inventory/target_machine.yaml deploy.yaml
```
