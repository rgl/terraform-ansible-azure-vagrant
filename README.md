# About

This shows a way to integrate terraform and ansible using the [nbering/terraform-provider-ansible](https://github.com/nbering/terraform-provider-ansible) terraform provider.

This is wrapped in a vagrant environment to make it easier to play with this stack without changing your local machine.

## Usage

If you are using Hyper-V, [configure Hyper-V in your local machine](https://github.com/rgl/windows-vagrant#hyper-v-usage) and start the vagrant environment.

If you are using libvirt, you should already known what to do.

Enter the created vagrant environment and play with the example terraform project:

```bash
# enter the vagrant environment.
vagrant ssh

# login into azure.
az login

# list the subscriptions and select the current one
# if the default is not OK.
az account list --all
az account show
az account set --subscription <YOUR-SUBSCRIPTION-ID>

# copy the example infrastructure to the local disk.
# NB this is needed because terraform/providers do not
#    work over the /vagrant shared directory.
rsync \
    -a \
    --delete \
    --exclude .vagrant/ \
    --exclude .git/ \
    --exclude .terraform/ \
    --exclude 'terraform.tfstate*' \
    /vagrant/ \
    $HOME/example/

# provision the example infrastructure.
cd $HOME/example/
export CHECKPOINT_DISABLE=1
export TF_LOG=TRACE
export TF_LOG_PATH=terraform.log
export TF_VAR_admin_username="$USER"
terraform init
terraform plan -out=tfplan
time terraform apply tfplan

# use the example infrastructure.
ansible-inventory --list --yaml
ansible-lint playbook.yml
ansible-playbook playbook.yml --syntax-check
ansible-playbook playbook.yml --list-hosts
ansible-playbook playbook.yml #-vvv
ansible -m ping all

# use the app.
wget -qSO- "http://$(terraform output app_ip_address)"

# use the app vm.
ssh-keygen -f ~/.ssh/known_hosts -R "$(terraform output app_ip_address)"
ssh "$(terraform output app_ip_address)"

# exit the app vm and destroy the whole infrastructure.
exit
terraform destroy
```

## Reference

* https://nicholasbering.ca/tools/2018/01/08/introducing-terraform-provider-ansible/
* https://github.com/nbering/terraform-provider-ansible
* https://github.com/nbering/terraform-inventory
