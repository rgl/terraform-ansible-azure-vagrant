#!/bin/bash
set -euxo pipefail

ansible_version='2.9.12'        # see https://pypi.org/project/ansible/
ansible_lint_version='4.3.3'    # see https://pypi.org/project/ansible-lint/

# install ansible.
# see https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip
apt-get install -y --no-install-recommends python3-pip sshpass
# NB this pip install will display several "error: invalid command 'bdist_wheel'"
#    messages, those can be ignored.
python3 -m pip install ansible==$ansible_version ansible-lint==$ansible_lint_version
install -d /etc/ansible
ansible --version
ansible -m ping localhost

# install the ansible shell completion helpers.
install -d /etc/bash_completion.d
apt-get install -y python3-argcomplete
activate-global-python-argcomplete3
