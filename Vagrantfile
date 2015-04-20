# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'

puppet_nodes = [
  {:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'fc-centos-6-6-x64-virtualbox', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
  {:hostname => 'client1', :ip => '172.16.32.11', :box => 'fc-centos-6-6-x64-virtualbox'},
  {:hostname => 'client2', :ip => '172.16.32.12', :box => 'fc-centos-6-6-x64-virtualbox'},
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = 'http://files.vagrantup.com/' + node_config.vm.box + '.box'
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end

      # Bootstrap puppet collections 1
      config.vm.provision :shell, :path => 'bootstrap-el.sh'

      config.vm.synced_folder ".", "/vagrant", disabled: true
      config.vm.synced_folder "./code/", "/etc/puppetlabs/code"
      #node_config.vm.provision :puppet do |puppet|
#        puppet.manifests_path = 'provision/manifests'
      #  puppet.options = "--debug"
      #  puppet.module_path = 'provision/modules'
      #end
    end
  end
end
