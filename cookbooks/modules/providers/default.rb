#
# Cookbook Name:: modules
# Provider:: modules
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 20012, Societe Publica.
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


def path
  new_resource.path ? new_resource.path : "/etc/modules-load.d/#{new_resource.name}.conf"
end

def serialize_options
  output = ""
  if new_resource.options
    new_resource.options.each do |option, value|
      output << " " + option + "=" + value
    end
  end
  return output
end

action :save do
  file path do
    content new_resource.name + serialize_options
    owner "root"
    group "root"
    mode "0644"
    notifies :start, "service[modules-load]"
  end
  new_resource.updated_by_last_action(true)
end

action :load do
  execute "load module" do
    command "modprobe #{new_ressource.module} #{serialize_options}"
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  file path do
    action :delete
  end
  execute "unload module" do
    command "modprobe -r #{new_ressource.module}"
  end
  new_resource.updated_by_last_action(true)
end
