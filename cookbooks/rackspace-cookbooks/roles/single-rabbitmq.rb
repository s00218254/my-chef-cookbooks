name "single-rabbitmq"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "role[rabbitmq-server]",
  "role[openstack-logging]"
)
