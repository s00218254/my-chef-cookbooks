name "single-glance"
description "Glance"
run_list(
  "role[base]",
  "role[glance-setup]",
  "role[glance-registry]",
  "role[glance-api]",
  "role[openstack-logging]"
)
