Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # Make this VM reachable on the host network as well, so that other
  # VM's running other browsers can access our dev server.
  config.vm.network "private_network", :ip => "192.168.10.200"
  config.vm.hostname = "rails-dev"

  # Adjust VM memory
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--cpus", "8"]
  end

  config.vm.synced_folder ".", "/vagrant"

  config.vm.network :forwarded_port, :guest => 1234, :host => 1234 # Debugger
  config.vm.network :forwarded_port, :guest => 3000, :host => 3000 # Server
  config.vm.network :forwarded_port, :guest => 5432, :host => 5432 # PostgreSQL

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
    puppet.manifest_file  = "default.pp"
  end

  # Copy required files for ssh connection to server
  config.vm.provision :shell, :inline => "cp /vagrant/puppet/files/key /home/vagrant/.ssh/id_rsa &&
                                          cp /vagrant/puppet/files/gemrc /home/vagrant/.gemrc &&
                                          cp /vagrant/puppet/files/gitconfig /home/vagrant/.gitconfig &&
                                          cat /vagrant/puppet/files/bashrc >> /home/vagrant/.bashrc &&
                                          chown vagrant:vagrant /home/vagrant/.ssh/id_rsa &&
                                          chmod 400 /home/vagrant/.ssh/id_rsa"
end
