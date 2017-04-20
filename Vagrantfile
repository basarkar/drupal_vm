# @file
# Requirements (one-time only)
# ============================
# - Vagrant: https://www.vagrantup.com/
# - Vagrant Triggers: https://github.com/emyl/vagrant-triggers
# - Setup local.cms.dnainfo.com in your hostfile.
#   1. Add this to /etc/hosts:
#      10.4.4.70 www.disignir.local
#   2. Flush local DNS cache
#      dscacheutil -flushcache
#
# General Notes
# ============================
# - Stop any other web servers that are running on your system,
#   e.g. any nginx processes on the host client
# - Synced Folders
#   Besides the application folder, the folder "/vagrant_downloads"
#   on the guest machine is mapped to the "~/Downloads" folder on
#   the host machine. You can place any files requires for
#   post-installation here (e.g. a database dump).
#
# Connecting to MySQL from host machine through SequelPro, Querious etc.
# ============================
# @see http://stackoverflow.com/questions/23959457/connect-to-mysql-on-vagrant-instance-with-sequel-pro
#
# MySQL Host: The IP address of the MySQL host which should be localhost or 127.0.0.1
# Username: MySQL database username.
# Password: The password connected to that MySQL database username.
# Database: Optional (database you want to connect to)
# Port: Default is 3306 so only change this if you definitely have to set to anything else.
#
# Now here you set the SSH settings for your Vagrant install:
# SSH Host: The hostname or IP address of your Vagrant machine (see config.vm.network)
# SSH User: The SSH username to that Vagrant machine (vagrant)
# SSH Password: The password connected to that SSH user (vagrant)
# SSH Port: Default is 22 so only change this if you definitely have to set to anything else.
#
# Permanently trust self-generated SSL certificate
# ============================
# @see http://www.robpeck.com/2010/10/google-chrome-mac-os-x-and-self-signed-ssl-certificates
# Either follow the instructions from the above article or open this file in
# your OSX Keychain and mark the "Trust" settings as "Always Trust"
#
# XDebug Setup with PHPStorm
# ============================
# For basic tutorial, see http://cl.ly/1v0X0o2q0F2v or the web version:
# https://danemacmillan.com/how-to-configure-xdebug-in-phpstorm-through-vagrant
#
# Follow the tutorial with a few modifications:
# - Adding a remote server: use path mappings for two folders, see http://cl.ly/image/1Q2M1T3g413w
# - Remote PHP interpreter setup: Connect to Vagrant machine using ssh credentials,
#   see http://cl.ly/image/2203381q383t. For the password, use "vagrant".
#   Connecting through the Vagrant file (currently) requires starting PHPStorm from the
#   command line,
#   @see http://stackoverflow.com/questions/31395112/error-setting-up-vagrant-with-virtualbox-in-pycharm-under-os-x-10-10
# - Example Screenshots
#   - PHPStorm Debug Settings: http://cl.ly/image/2Y200y2u190k
#   - PHPStorm Server Settings: http://cl.ly/image/352o0U2a3G1E
#   - PHPStorm Interpreter Settings: http://cl.ly/image/442x3x3R1t3x
#   - PHPStorm Run Configuration Settings: http://cl.ly/image/1I0a3e2e3P1j



# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"


  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
   config.vm.network "forwarded_port", guest: 80, host: 8081
   config.vm.network "forwarded_port", guest: 3306, host:33310

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
   config.vm.network "private_network", ip: "10.4.4.70"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~/Downloads", "/vagrant_downloads"
  config.vm.synced_folder "./", "/var/www/dev", id: "project-root",
    owner: "vagrant",
    group: "www-data",
     mount_options: ["dmode=775,fmode=664"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true


    # By default, the NAT network is located at 10.0.2.0/16. If the local
    # network is using this range, vagrant ssh will be unable to connect,
    # thus preventing shared folders from being configured.
    # 192.168.100/24 means addresses will be assigned in the
    # range 192.168.100.0 - 192.168.100.255 (ie. 24 bits are locked down).
    vb.customize ["modifyvm", :id, "--natnet1", "10.100.02/24"]

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  #config.vm.provision "fix-no-tty", type: "shell" do |s|
  #    s.privileged = false
  #    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  #end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", path: "configs/vagrant/vagrant_provision.sh"

  # Run a trigger after system gets provisioned, up and reloaded.
  # Requires Vagrant Triggers plugin
  # @see https://github.com/emyl/vagrant-triggers
  #
  # Keep weird formatting in place, otherwise script might not run successfully.
  # @see http://salvatore.garbesi.com/vagrant-port-forwarding-on-mac/
  # @see http://gielberkers.com/fixing-vagrant-port-forwarding-osx-yosemite/
  # @see http://salferrarello.com/mac-pfctl-port-forwarding/
  config.trigger.after [:provision, :up, :reload] do
system('echo "
rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8081
rdr pass inet proto tcp from any to any port 443 -> 127.0.0.1 port 8443
" | sudo pfctl -ef - >/dev/null 2>&1; echo "==> Add Port Forwarding (80 => 8081)\n==> Add Port Forwarding (443 => 8443)\n==> Enabling Port Forwarding"')
  end

  # Run a trigger after system gets halted or destroyed.
  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling Port Forwarding'")
  end
end
