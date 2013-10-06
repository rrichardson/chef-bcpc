

package "hbase-regionserver" do 
	action :upgrade
end

service "hbase-regionserver" do 
	action [:enable, :restart]
end
