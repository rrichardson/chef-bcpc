%w{hadoop-hdfs-namenode hadoop-hdfs-zkfc}.each do |pkg|
  package pkg do
    action :upgrade
  end
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

service "hadoop-hdf-zkfs" do 
  action :restart
end

