%w{hadoop-hdfs-namenode hadoop-hdfs-zkfc}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

(1..4).each do |i| 

	directory "/disk#{i}/dfs/nn" do
		owner "hdfs"
		group "hdfs"
    mode 0700
		action :create
	end
	
  directory "/disk#{i}/dfs/namedir" do
		owner "hdfs"
		group "hdfs"
    mode 0700
		action :create
	end

end

bash "format namenode" do
   code "hadoop namenode -format"
   user "hdfs"
   action :run
end

if node[:bpcp][:hadoop][:standby_namenode] then 

  bash "boostrap-standby-namenode" do
    code "hdfs namenode -bootstrapStandby"
    action :run
    user "hdfs"
  end
end

service "hadoop-hdfs-namenode" do 
  action :restart
end

service "hadoop-hdfs-zkfs" do 
  action :restart
end

