# keep first three bytes of network address
# later it will concat with ip_httpd_host so we have full address
ip_addr_base = "192.168.56."

# keep host part of httpd-server ip-address; it is the beginning point for tomcats adresses
# e.g. if ip_httpd_host = 10, then tomcat1 = ...11, tomcat2 = ...12
ip_httpd_host = 10

tomcats_dict = { 1 => "tomcat-server1", 2 => "tomcat-server2" }

Vagrant.configure("2") do |config|
  config.vm.box = "sbeliakou/centos"
  
  # httpd config
  config.vm.define "httpd-server" do |httpd_config|
    httpd_config.vm.network "private_network", ip: "#{ip_addr_base}#{ip_httpd_host}"
    httpd_config.vm.hostname = "httpd-server"
	httpd_config.vm.provision 'shell', path: "httpd_provision.sh", args: "#{ip_addr_base}#{ip_httpd_host + 1} #{ip_addr_base}#{ip_httpd_host + 2}", privileged: "true"
	# provider settings
	httpd_config.vm.provider "virtualbox" do |vb|
	  vb.name = "Vagrant-HTTPD-VM"
	  vb.memory = "1024"
	end
  end
  
  # tomcats config
  (1..2).each do |i|
    config.vm.define tomcats_dict[i] do |tomcat_config|
      tomcat_config.vm.network "private_network", ip: "#{ip_addr_base}#{ip_httpd_host + i}"
      tomcat_config.vm.hostname = tomcats_dict[i]
	  tomcat_config.vm.provision 'shell', path: "tomcat_provision.sh", args: "#{i}", privileged: "true"
	  # provider settings
	  tomcat_config.vm.provider "virtualbox" do |vb|
	    vb.name = "Vagrant-Tomcat#{i}-VM"
	    vb.memory = "2048"
	  end
	end
  end

end
