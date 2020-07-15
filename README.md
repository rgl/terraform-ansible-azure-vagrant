# About

This shows a way to integrate terraform and ansible using the [nbering/terraform-provider-ansible](https://github.com/nbering/terraform-provider-ansible) terraform provider.

This is wrapped in a vagrant environment to make it easier to play with this stack without changing your local machine.

## Usage

Install Hyper-V in your local machine.

[Configure Hyper-V in your local machine](https://github.com/rgl/windows-vagrant#hyper-v-usage) and start the vagrant environment.

Enter the created vagrant environment and play with the example terraform project:

```bash
# enter the vagrant environment.
vagrant ssh

# login into azure.
az login

# copy the example infrastructure to the local disk.
# NB this is needed because terraform/providers do not
#    work over the /vagrant shared directory.
rsync \
    -a \
    --delete \
    --exclude .vagrant/ \
    --explude .git/ \
    /vagrant/ \
    $HOME/example/

# provision the example infrastructure.
cd $HOME/example/
terraform init
terraform plan -out=tfplan
time terraform apply tfplan

# use the example infrastructure.
source /opt/ansible/bin/activate
ansible-inventory --list --yaml
ansible-lint playbook.yml
ansible-playbook playbook.yml --syntax-check
ansible-playbook playbook.yml --list-hosts
ansible-playbook playbook.yml #-vvv
```

## Reference

* https://nicholasbering.ca/tools/2018/01/08/introducing-terraform-provider-ansible/
* https://github.com/nbering/terraform-provider-ansible
* https://github.com/nbering/terraform-inventory
