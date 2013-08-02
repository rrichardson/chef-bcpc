
#
# Cookbook Name:: bcpc
# Recipe:: ceph-osd
#
# Copyright 2013, Bloomberg L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#RGW Stuff
#Note, currently rgw cannot use Keystone to auth S3 requests, only swift, so for the time being we'll have
#to manually provision accounts for RGW in the radosgw-admin tool

include_recipe "bcpc::ceph-common"

apt_repository "ceph-fcgi" do
    uri node['bcpc']['repos']['ceph-fcgi']
    distribution node['lsb']['codename']
    components ["main"]
    key "ceph-release.key"
end

apt_repository "ceph-apache" do
    uri node['bcpc']['repos']['ceph-apache']
    distribution node['lsb']['codename']
    components ["main"]
    key "ceph-release.key"
end


%w{apache2 lib-apache2-mod-fastcgi}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

#I'm not sure what this does but it was in the ceph QA chef recipe
package 'libfcgi0ldbl'

service "apache2" do
  action [ :disable, :stop ]
end


directory "/var/lib/ceph/radosgw/ceph-client.radosgw.gateway"
  owner "root"
  group "root"
  mode 0755
  action :create
end

file "/var/lib/ceph/radosgw/ceph-client.radosgw.gateway/done" do
  owner "root"
  group "root"
  mode "0644"
  action :touch
end


bash "write-client-radosgw-key" do
    code <<-EOH
        RGW_KEY=`ceph --name client.admin --keyring /etc/ceph/ceph.client.admin.keyring auth get-or-create-key client.radosgw.gateway osd 'allow rwx' mon 'allow r'`
        ceph-authtool "/var/lib/ceph/radosgw/ceph-client.radosgw.gateway/keyring" \
            --create-keyring \
            --name=client.radosgw.gateway \
            --add-key="$RGW_KEY"
    EOH
    not_if "test -f /var/lib/ceph/radosgw/ceph-client.radosgw.gateway/keyring && chmod 644 /var/lib/ceph/radosgw/ceph-client.radosgw.gateway/keyring" 
end


execute "ceph-radosgw-start" do
   command <<-EOH
        restart radosgw-all-starter
   EOH
end

service "apache2" do
  action :start
end
