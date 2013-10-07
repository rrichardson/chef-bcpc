

%w{hadoop-hdfs-journalnode}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

directory node[:bcpc][:hadoop][:journal][:path] do
  owner "hdfs"
  group "hdfs"
  mode 0700
  action :create
end

service "hadoop-hdfs-journalnode" do
	action :restart
end

