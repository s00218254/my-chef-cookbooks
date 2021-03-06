#
# Cookbook Name:: nova-network
# Attributes:: default
#
# Copyright 2012-2013, Rackspace US, Inc.
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
default["nova"]["network"]["provider"] = "neutron"

# ######################################################################### #
# Nova-Network Configuration Attributes
# ######################################################################### #
# TODO(shep): This should probably be ['nova']['network']['fixed']
default["nova"]["networks"]["public"] = {
  "label" => "public",
  "ipv4_cidr" => "192.168.100.0/24",
  "bridge" => "br100",
  "bridge_dev" => "eth2",
  "dns1" => "8.8.8.8",
  "dns2" => "8.8.4.4"
}
# Specify other networks in the environment file, e.g:
#default["nova"]["networks"]["private"] = {
#  "label" => "private",
#  "ipv4_cidr" => "192.168.200.0/24",
#  "bridge" => "br200",
#  "bridge_dev" => "eth3",
#  "dns1" => "8.8.8.8",
#  "dns2" => "8.8.4.4"
#}

default["nova"]["network"]["public_interface"] = "eth0"
default["nova"]["network"]["dmz_cidr"] = "10.128.0.0/24"
default["nova"]["network"]["network_manager"] = "nova.network.manager.FlatDHCPManager"
default["nova"]["network"]["dhcp_domain"] = "novalocal"
default["nova"]["network"]["force_dhcp_release"] = true
default["nova"]["network"]["send_arp_for_ha"] = true
default["nova"]["network"]["auto_assign_floating_ip"] = false
default["nova"]["network"]["floating_pool_name"] = "nova"
default["nova"]["network"]["multi_host"] = true
default["nova"]["network"]["dhcp_lease_time"] = 120
default["nova"]["network"]["fixed_ip_disassociate_timeout"] = 600

# ######################################################################### #
# Neutron Configuration Attributes
# ######################################################################### #
# nova.conf options for neutron
default["neutron"]["network_api_class"] = "nova.network.neutronv2.api.API"
default["neutron"]["auth_strategy"] = "keystone"
default["neutron"]["libvirt_vif_type"] = "ethernet"
default["neutron"]["libvirt_vif_driver"] =
  "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver"
default["neutron"]["linuxnet_interface_driver"] =
  "nova.network.linux_net.LinuxOVSInterfaceDriver"
default["neutron"]["firewall_driver"] =
  "nova.virt.firewall.NoopFirewallDriver"
default["neutron"]["security_group_api"] = "neutron"
default["neutron"]["isolated_metadata"] = "True"
default["neutron"]["service_neutron_metadata_proxy"] = "True"
default["neutron"]["agent_down_time"] = 30

default["neutron"]["services"]["api"]["scheme"] = "http"
default["neutron"]["services"]["api"]["network"] = "public"
default["neutron"]["services"]["api"]["port"] = 9696
default["neutron"]["services"]["api"]["path"] = ""
default["neutron"]["services"]["api"]["cert_file"] = "neutron.pem"
default["neutron"]["services"]["api"]["key_file"] = "neutron.key"
default["neutron"]["services"]["api"]["wsgi_file"] = "neutron-server"

default["neutron"]["db"]["name"] = "neutron"
default["neutron"]["db"]["username"] = "neutron"

default["neutron"]["service_tenant_name"] = "service"
default["neutron"]["service_user"] = "neutron"
default["neutron"]["service_role"] = "admin"
default["neutron"]["service_pass"] = "Galax8800"
default["neutron"]["debug"] = "True"
default["neutron"]["verbose"] = "False"

default["neutron"]["overlap_ips"] = "True"
default["neutron"]["use_namespaces"] = "True" # should correspond to overlap_ips used for dhcp agent and l3 agent.

# Manage plugins here, currently only supports openvswitch (ovs)
default["neutron"]["plugin"] = "ovs"

# l3 agent placeholders
default["neutron"]["l3"]["router_id"] = ""
default["neutron"]["l3"]["gateway_external_net_id"] = ""

# dhcp agent options
default["neutron"]["dhcp_lease_time"] = "1440"
default["neutron"]["dhcp_domain"] = "openstacklocal"

# neutron.conf options
default["neutron"]["quota_items"] = "network,subnet,port"
default["neutron"]["default_quota"] = "-1"
default["neutron"]["quota_network"] = "10"
default["neutron"]["quota_subnet"] = "10"
default["neutron"]["quota_port"] = "50"
default["neutron"]["quota_driver"] = "neutron.db.quota_db.DbQuotaDriver"

# Plugin defaults
# OVS
default["neutron"]["ovs"]["network_type"] = "vlan"
default["neutron"]["ovs"]["tunnel_ranges"] = "1:1000"           # Enumerating ranges of GRE tunnel IDs that are available for tenant network allocation (if GRE)
default["neutron"]["ovs"]["integration_bridge"] = "br-int"      # Don't change without a good reason..
default["neutron"]["ovs"]["tunnel_bridge"] = "br-tun"           # only used if tunnel_ranges is set
default["neutron"]["ovs"]["external_bridge"] = "br-ex"
default["neutron"]["ovs"]["data_interface"] = "eth1"
default["neutron"]["ovs"]["external_interface"] = "eth2"
default["neutron"]["ovs"]["network"]="nova"
default["neutron"]["ovs"]["firewall_driver"] =
  "neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver"

case platform

when "fedora", "redhat", "centos"

  # Array of all the provider based networks to create
  default["neutron"]["ovs"]["provider_networks"] = [
    {
      "label" => "ph-em2",
      "bridge" => "br-em2",
      "vlans" => "1:1000"
    }
  ]
  default["nova-network"]["platform"] = {
    "nova_network_packages" => ["iptables", "openstack-nova-network"],
    "nova_network_service" => "openstack-nova-network",
    "common_packages" => ["openstack-nova-common", "python-cinderclient"]
  }

  default["neutron"]["platform"] = {
    "epel_openstack_packages" => ["kernel", "iproute"],
    "mysql_python_packages" => ["MySQL-python"],
    "neutron_api_packages" => ["openstack-neutron"],
    "neutron_common_packages" => [
      "python-neutronclient",
      "openstack-neutron",
      "bridge-utils"
    ],
    "neutron_dhcp_packages" => ["openstack-neutron"],
    "neutron-dhcp-agent" => "neutron-dhcp-agent",
    "neutron_l3_packages" => ["openstack-neutron"],
    "neutron-l3-agent" => "neutron-l3-agent",
    "neutron_metadata_packages" => ["openstack-neutron"],
    "neutron-metadata-agent" => "neutron-metadata-agent",
    "neutron_api_service" => "neutron-server",
    "neutron_api_process_name" => "neutron-server",
    "package_overrides" => "",
    "neutron_ovs_packages" => [
      'openstack-neutron-openvswitch'
    ],
    "neutron_ovs_service_name" => "neutron-openvswitch-agent",
    "neutron_openvswitch_service_name" => "openvswitch"
  }
  default["neutron"]["ssl"]["dir"] = "/etc/pki/tls"
  default["neutron"]["ovs_use_veth"] = "True"

when "ubuntu"

  # Array of all the provider based networks to create
  default["neutron"]["ovs"]["provider_networks"] = [
    {
      "label" => "physnet",
      "bridge" => "br-#{node["neutron"]["ovs"]["data_interface"]}",
      "vlans" => "#{node["neutron"]["ovs"]["vlan_ranges"]}"
    }
  ]

  default["nova-network"]["platform"] = {
    "nova_network_packages" => ["iptables", "nova-network"],
    "nova_network_service" => "nova-network",
    "common_packages" => ["nova-common", "python-nova", "python-novaclient"]
  }

  default["neutron"]["platform"] = {
    "mysql_python_packages" => ["python-mysqldb"],
    "neutron_common_packages" => ["python-neutronclient",
      "neutron-common", "python-neutron"],

    "neutron_api_packages" => ["neutron-server"],
    "neutron_api_process_name" => "neutron-server",
    "neutron_api_service" => "neutron-server",

    "neutron_dhcp_packages" => ["dnsmasq-base", "dnsmasq-utils",
      "libnetfilter-conntrack3", "neutron-dhcp-agent" ],
    "neutron-dhcp-agent" => "neutron-dhcp-agent",

    "neutron_l3_packages" => ["neutron-l3-agent"],
    "neutron-l3-agent" => "neutron-l3-agent",

    "neutron_metadata_packages" => ["neutron-metadata-agent"],
    "neutron-metadata-agent" => "neutron-metadata-agent",

    "package_overrides" => "-o Dpkg::Options::='--force-confold' "\
      "-o Dpkg::Options::='--force-confdef'",

    "neutron_ovs_packages" => [
      "openvswitch-datapath-lts-raring-dkms",
      "neutron-plugin-openvswitch",
      "neutron-plugin-openvswitch-agent"
    ],
    "neutron_ovs_service_name" => "neutron-plugin-openvswitch-agent",
    "neutron_openvswitch_service_name" => "openvswitch-switch"
  }
  default["neutron"]["ssl"]["dir"] = "/etc/ssl"
  default["neutron"]["ovs_use_veth"] = "False"
end
