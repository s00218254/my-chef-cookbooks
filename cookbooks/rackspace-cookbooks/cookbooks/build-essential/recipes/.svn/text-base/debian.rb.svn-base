#
# Cookbook Name:: build-essential
# Recipe:: debian
#
# Copyright 2008-2013, Opscode, Inc.
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

# on apt-based platforms when first provisioning we need to force
# apt-get update at compiletime if we are going to try to install at compiletime
#将修改源的操作移到pre-intall.sh
#execute "change sources.list" do
#   action :nothing
#   command 'cp /etc/apt/sources.list /etc/apt/sources.list-bak;sed -i "s/us.archive.ubuntu.com/192.168.83.50\/ubuntu-us/g" /etc/apt/sources.list; sed -i "s/^deb-src/#deb-src/g" /etc/apt/sources.list; sed -i "s/security.ubuntu.com/192.168.83.50\/ubuntu-security/g" /etc/apt/sources.list'
#   only_if do
#     node["osops"]["change_sources"] == true
#   end
#end.run_action(:run) if node['build_essential']['compiletime']

#execute "change /etc/hosts" do
#   action :nothing
#   command 'sed -i "s/\(.*\).local.lan/`ifconfig eth0 |grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "`/g" /etc/hosts'
#   only_if do
#     node["osops"]["change_sources"] == true
#   end
#end.run_action(:run) if node['build_essential']['compiletime']

execute "apt-get-update-build-essentials" do
  command "apt-get update"
  action :nothing
  # tip: to suppress this running every time, just use the apt cookbook
  not_if do
    ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    ::File.mtime('/var/lib/apt/periodic/update-success-stamp') > Time.now - 86400*2
  end
end.run_action(:run) if node['build_essential']['compiletime']

%w{
  autoconf
  binutils-doc
  bison
  build-essential
  flex
}.each do |pkg|

  r = package pkg do
    action( node['build_essential']['compiletime'] ? :nothing : :install )
  end
  r.run_action(:install) if node['build_essential']['compiletime']

end
