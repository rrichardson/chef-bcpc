
services = %w{hbase-master hbase-rest}

services.each do |p| 
	package p do 
		action :upgrade
	end
end

services.each do |p|
	service p do
		action [:enable, :restart]
	end
end

%w{hadoop-metrics.properties
   hbase-env.sh
   hbase-policy.xml
   hbase-site.xml
   log4j.properties
   regionservers}.each do |t| 
  template "/etc/hbase/conf/#{t}" do 
    source "hb_#{t}.erb"
    variables(:hh_hosts => get_hadoop_heads , :journal_hosts => get_hadoop_journal_nodes, :zk_servers => get_zk_ensemble)
  end
end

