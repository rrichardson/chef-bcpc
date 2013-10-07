
%w{hadoop-yarn-resourcemanager hadoop-client}.each do |pkg|
    package pkg do
        action :upgrade
    end
end


#don't run this right away, wait for a zk quorum to come up
#this will be triggered by a zookeeper recipe 
bash "format-zk-hfds-ha" do 
	code "hdfs zkfc -formatZK"
	action :nothing
	user "hdfs"
end


service "hadoop-yarn-resourcemanager" do
	action [:enable, :restart]
end

