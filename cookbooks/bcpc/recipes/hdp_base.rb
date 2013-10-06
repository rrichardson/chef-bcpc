

case node["platform_family"]
when "debian"
	apt_repository "cloudera" do
			uri node['bcpc']['repos']['cloudera']
			distribution node['lsb']['codename'] + '-cdh4'
			components ["contrib"]
			key "cloudera-archive.key"
	end

	%w{hadoop hbase hive oozie pig}.each do |w| 
		directory "/etc/#{w}/conf.bcpc" do
			owner "root"
			group "root"
			mode 00644
			action :create
			recursive true
		end
	
		bash "update-#{w}-conf-alternatives" do
			code %{
				update-alternatives --install /etc/#{w}/conf #{w}-conf /etc/#{w}/conf.bcpc 50
				update-alternatives --set #{w}-conf /etc/#{w}/conf.bcpc
			}
		end
	end
	
end	
when "rhel"
  # do things on RHEL platforms (redhat, centos, scientific, etc)
end

