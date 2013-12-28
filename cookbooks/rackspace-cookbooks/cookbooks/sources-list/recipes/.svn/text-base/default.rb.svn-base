#
# Cookbook Name:: sources-list
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
node.set['build_essential']['compiletime'] = true

execute "back up  sources.list" do
   action :nothing
   command "cp /etc/apt/sources.list /etc/apt/sources.list-bak"
end.run_action(:run) if node['build_essential']['compiletime']

execute "change sources.list" do
   action :nothing
   command 'cp /etc/apt/sources.list /etc/apt/sources.list-bak;sed -i "s/us.archive.ubuntu.com/192.168.83.50\/ubuntu-us/g" /etc/apt/sources.list; sed -i "s/^deb-src/#deb-src/g" /etc/apt/sources.list; sed -i "s/security.ubuntu.com/192.168.83.50\/ubuntu-security/g" /etc/apt/sources.list'
end.run_action(:run) if node['build_essential']['compiletime']
