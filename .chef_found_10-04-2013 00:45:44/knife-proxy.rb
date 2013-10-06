log_level                :info
log_location             STDOUT
node_name                'ubuntu'
client_key               '/home/ubuntu/chef-bcpc/.chef/ubuntu.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'http://10.0.100.3:4000'
cache_type               'BasicFile'
cache_options( :path => '/home/ubuntu/chef-bcpc/.chef/checksums' )
cookbook_path [ './cookbooks' ]
