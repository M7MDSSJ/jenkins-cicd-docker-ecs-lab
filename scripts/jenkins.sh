# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # ================================
  # Nexus VM with CentOS Stream 9
  # ================================
  config.vm.define "nexus" do |nexus|
    nexus.vm.box = "eurolinux-vagrant/centos-stream-9"
    nexus.vm.hostname = "nexus-lab"
    nexus.vm.network "private_network", ip: "192.168.33.11"
    nexus.vm.network "public_network"
    nexus.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
      vb.name = "Nexus-Lab-VM"
    end
    nexus.vm.provision "shell", path: "nexus.sh"
  end
  # ================================
  # SonarQube VM
  # ================================
  config.vm.define "sonarqube" do |sonar|
    sonar.vm.box = "ubuntu/jammy64"
    sonar.vm.hostname = "sonarqube-lab"
    sonar.vm.network "private_network", ip: "192.168.33.12"
    sonar.vm.network "public_network"
    sonar.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
      vb.name = "SonarQube-Lab-VM"
    end
    sonar.vm.provision "shell", path: "sonarqube.sh"
  end
  # ================================
  # Jenkins VM
  # ================================
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "ubuntu/jammy64"
    jenkins.vm.hostname = "jenkins-lab"
    jenkins.vm.network "private_network", ip: "192.168.33.13"
    jenkins.vm.network "public_network"
    jenkins.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.name = "Jenkins-Lab-VM"
    end
    jenkins.vm.provision "shell", path: "jenkins.sh"
  end
end
