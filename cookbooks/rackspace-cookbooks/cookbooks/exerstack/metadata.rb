name              "exerstack"
maintainer        "Rackspace Hosting, Inc."
license           "Apache 2.0"
description       "exerstack module"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "4.2.0"

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{ osops-utils sysctl }.each do |dep|
  depends dep
end
