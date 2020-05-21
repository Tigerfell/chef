name "stormfly-03"
description "Master role applied to stormfly-03"

default_attributes(
  :networking => {
    :interfaces => {
      :external_ipv4 => {
        :interface => "eno1",
        :role => :external,
        :family => :inet,
        :address => "140.211.167.99"
      },
      :external_ipv6 => {
        :interface => "eno1",
        :role => :external,
        :family => :inet6,
        :address => "2605:bc80:3010:700::8cd3:a763"
      }
    }
  }
)

run_list(
  "role[osuosl]"
)
