#
# Cookbook Name:: apt
# Recipe:: default
#
# Copyright 2008-2013, Opscode, Inc.
# Copyright 2009, Bryan McLellan <btm@loftninjas.org>
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
# Run apt-get update to create the stamp file
#将修改源的操作移到pre-install.sh
#execute "change sources.list" do
#   action :nothing
#   command 'cp /etc/apt/sources.list /etc/apt/sources.list-bak;sed -i "s/us.archive.ubuntu.com/192.168.83.50\/ubuntu-us/g" /etc/apt/sources.list; sed -i "s/^deb-src/#deb-src/g" /etc/apt/sources.list; sed -i "s/security.ubuntu.com/192.168.83.50\/ubuntu-security/g" /etc/apt/sources.list'
#   only_if do
#     node["osops"]["change_sources"] == true
#   end
#end
#execute "change /etc/hosts" do
#   action :nothing
#   command 'sed -i "s/\(.*\).local.lan/`ifconfig eth0 |grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "`/g" /etc/hosts'
#   only_if do
#     node["osops"]["change_sources"] == true
#   end
#end

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  not_if do ::File.exists?('/var/lib/apt/periodic/update-success-stamp') end
end

# For other recipes to call to force an update
execute "apt-get update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

# Automatically remove packages that are no longer needed for dependencies
execute "apt-get autoremove" do
  command "apt-get -y autoremove"
  action :nothing
end

# Automatically remove .deb files for packages no longer on your system
execute "apt-get autoclean" do
  command "apt-get -y autoclean"
  action :nothing
end

# provides /var/lib/apt/periodic/update-success-stamp on apt-get update
package "update-notifier-common" do
  notifies :run, 'execute[apt-get-update]', :immediately
end

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    ::File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

%w{/var/cache/local /var/cache/local/preseeding}.each do |dirname|
  directory dirname do
    owner "root"
    group "root"
    mode  00755
    action :create
  end
end
