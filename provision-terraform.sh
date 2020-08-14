#!/bin/bash
set -euxo pipefail

terraform_version='0.12.29'                   # see https://github.com/hashicorp/terraform/releases
terraform_provider_ansible_version='1.0.3'    # see https://github.com/nbering/terraform-provider-ansible/releases
ansible_terraform_inventory_version='2.2.0'   # see https://github.com/nbering/terraform-inventory/releases

# install terraform.
wget -q https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_linux_amd64.zip
unzip terraform_${terraform_version}_linux_amd64.zip
install \
  -m 755 \
  terraform \
  /usr/local/bin
rm terraform terraform_${terraform_version}_linux_amd64.zip

# install the terraform ansible provider.
# NB this has to be installed into the user home.
wget -q https://github.com/nbering/terraform-provider-ansible/releases/download/v$terraform_provider_ansible_version/terraform-provider-ansible-linux_amd64.zip
unzip terraform-provider-ansible-linux_amd64.zip
install -d -o vagrant -g vagrant /home/vagrant/.terraform.d/plugins/linux_amd64
install \
  -m 755 \
  -o vagrant \
  -g vagrant \
  linux_amd64/terraform-provider-ansible_v$terraform_provider_ansible_version \
  /home/vagrant/.terraform.d/plugins/linux_amd64/terraform-provider-ansible
rm terraform-provider-ansible-linux_amd64.zip

# install the ansible terraform dynamic inventory provider.
wget -q https://github.com/nbering/terraform-inventory/releases/download/v$ansible_terraform_inventory_version/terraform.py
install \
  -m 755 \
  terraform.py \
  /opt/ansible/bin/ansible-terraform-inventory.py
rm terraform.py
