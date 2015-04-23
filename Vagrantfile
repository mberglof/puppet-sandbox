# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'

puppet_nodes = [
  {:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'puppetlabs/centos-7.0-64-puppet', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
  {:hostname => 'client1', :ip => '172.16.32.11', :box => 'vStone/centos-6.x-puppet.3.x'},
  {:hostname => 'client2', :ip => '172.16.32.12', :box => 'puppetlabs/centos-7.0-64-puppet'},
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = 'https://vagrantcloud.com/' + node_config.vm.box
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
        config.vm.synced_folder "librarian/", "/librarian"
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end

      $hack = <<HACK
      yum makecache fast
      yum install -y ruby ruby-devel rubygem-bundler git
      bundle install --gemfile /librarian/Gemfile
      cd /librarian
      /usr/local/bin/librarian-puppet install --verbose
HACK

      if node[:hostname] == "puppet"
        config.vm.provision :shell, inline: $hack
      end

      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'
      end
    end
  end
end
