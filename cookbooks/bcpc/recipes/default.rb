#
# Cookbook Name:: bcpc
# Recipe:: default
#
# Copyright 2013, Bloomberg Finance L.P.
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

require 'ipaddr'

node.set['bcpc']['management']['ip'] = node['network']['interfaces'][node['bcpc']['management']['interface']]['addresses'].select {|k,v| v['family'] == "inet" and k != node['bcpc']['management']['vip'] }[0].first

bitlen = (node['bcpc']['management']['cidr'].match /\d+\.\d+\.\d+\.\d+\/(\d+)/)[1].to_i
hostaddr = IPAddr.new(node['bcpc']['management']['ip'])<<bitlen>>bitlen

node.set['bcpc']['node_number'] = hostaddr.to_i.to_s
node.set['bcpc']['storage']['ip'] = ((IPAddr.new(node['bcpc']['storage']['cidr'])>>(32-bitlen)<<(32-bitlen))|hostaddr).to_s
node.set['bcpc']['floating']['ip'] = ((IPAddr.new(node['bcpc']['floating']['cidr'])>>(32-bitlen)<<(32-bitlen))|hostaddr).to_s

node.save
