
services = %w{hbase-master hase-rest}

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
