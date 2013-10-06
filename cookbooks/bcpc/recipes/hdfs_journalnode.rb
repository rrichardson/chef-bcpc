

%w{hadoop-hdfs-journalnode}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

service "hadoop-hdfs-journalnode" do
	action :restart
end
