Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu-20.04-amd64'

  # NB this is needed because terraform/providers do not
  #    work over the /vagrant network shared directory.
  config.vm.synced_folder '.', '/vagrant', type: 'rsync', rsync__exclude: [
    ".vagrant/",
    ".git/",
    ".terraform/",
    'terraform.tfstate*',
  ]

  config.vm.provider 'libvirt' do |lv, config|
    lv.memory = 2*1024
    lv.cpus = 4
    lv.cpu_mode = 'host-passthrough'
    lv.nested = true
    lv.keymap = 'pt'
  end

  config.vm.provider 'hyperv' do |hv, config|
    hv.linked_clone = true
    hv.memory = 2*1024
    hv.cpus = 2
    hv.enable_virtualization_extensions = true # nested virtualization.
    hv.vlan_id = ENV['HYPERV_VLAN_ID']
    # see https://github.com/hashicorp/vagrant/issues/7915
    # see https://github.com/hashicorp/vagrant/blob/10faa599e7c10541f8b7acf2f8a23727d4d44b6e/plugins/providers/hyperv/action/configure.rb#L21-L35
    config.vm.network :private_network, bridge: ENV['HYPERV_SWITCH_NAME'] if ENV['HYPERV_SWITCH_NAME']
  end

  config.vm.provision :shell, path: 'provision-base.sh'
  config.vm.provision :shell, path: 'provision-azure-cli.sh'
  config.vm.provision :shell, path: 'provision-ansible.sh'
  config.vm.provision :shell, path: 'provision-terraform.sh'
  config.vm.provision :shell, path: 'summary.sh'
end
