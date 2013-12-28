Support
=======

Issues have been disabled for this repository.  
Any issues with this cookbook should be raised here:

[https://github.com/rcbops/chef-cookbooks/issues](https://github.com/rcbops/chef-cookbooks/issues)

Please title the issue as follows:

[modules]: \<short description of problem\>

In the issue description, please include a longer description of the issue, along with any relevant log/command/error output.  
If logfiles are extremely long, please place the relevant portion into the issue description, and link to a gist containing the entire logfile

Please see the [contribution guidelines](CONTRIBUTING.md) for more information about contributing to this cookbook.

modules-cookbook
================

= DESCRIPTION:
Chef cookbook to manage linux modules with /etc/modules and modprobe (linux 2.6 +)

= REQUIREMENTS:

Linux 2.6+
Ubuntu >9.10 (for the moment. use upstart and not init, any contribution is welcome)

= ATTRIBUTES:
node[:modules] = A namespace for modules settings.

= USAGE:
There are two ways of setting sysctl values:
1. Set chef attributes in the _sysctl_ namespace, E.G.:
 <tt>default[:modules][:loop]</tt>
2. With Ressource/Provider

Resource/Provider
=================

This cookbook includes LWRPs for managing:
* modules
* modules_multi

modules
--------

# Actions

- :save: save and load a module (default)
- :load: load a module
- :remove: remove a (previous save) module.

# Attribute Parameters

- variable: variable to manage. "net.ipv4.ip_forward", "vm.swappiness" ...
- value: value to affect to variable. "1", "0" ...
- path: path to a specific file

# Examples


modules_multi
------------

#Actions

- :save: save and set a sysctl value (default)
- :set: set a sysctl value
- :remove: remove a (previous set) sysctl.

# Attribute Parameters

- instructions: hash with instruction {variable => value, variable2 => value2}. override use of "variable" and "value".
- path: path to a specific file

# Examples
