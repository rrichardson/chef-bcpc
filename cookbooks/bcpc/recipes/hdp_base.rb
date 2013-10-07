

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
			mode 00755
			action :create
			recursive true
		end

		bash "update-#{w}-conf-alternatives" do
			code %Q{
				update-alternatives --install /etc/#{w}/conf #{w}-conf /etc/#{w}/conf.bcpc 50
				update-alternatives --set #{w}-conf /etc/#{w}/conf.bcpc
			}
		end
	end

when "rhel" # do things on RHEL platforms (redhat, centos, scientific, etc)
   "run away"
end

package "zookeeper" do
  action :upgrade
end

%w{capacity-scheduler.xml
   container-executor.cfg
   core-site.xml
   hadoop-metrics2.properties
   hadoop-metrics.properties
   hadoop-policy.xml
   hdfs-site.xml
   log4j.properties
   mapred-site.xml
   slaves
   ssl-client.xml
   ssl-server.xml
   yarn-env.sh
   yarn-site.xml}.each do |t|
  template "/etc/hadoop/conf/#{t}" do
    source "hdp_#{t}.erb"
    variables (:hh_hosts => get_hadoop_heads, :journal_hosts => get_hadoop_journal_nodes, :zk_servers => get_zk_ensemble)
  end
end

