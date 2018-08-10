software:

# Network configuration:
  network:
    ens192:
      set_type: 'single'
      set_ipaddr: '172.18.0.64'
      set_netmask: '255.255.255.0'
      set_gateway: '172.18.0.254'

# DNS search and servers:
  dns:
    search: 'blacknet.lan'
    servers:
      - '172.18.0.254'

# NTP servers:
  ntp:
    servers:
      - ntp1.sth.netnod.se
      - ntp2.sth.netnod.se

# SSHD Options:
  ssh:
    - source: '172.18.0.0/24'
    - interface: 'ens192'

# Firewall settings:
  firewall:
    - enable: False
#    - rules:
#      - 'TCP,4505,172.18.0.0/24'
#      - 'TCP,4506,172.18.0.0/24'

# SNMP settings:
  snmp:
    user: rouser
    sha: 'monkeylikebanana'
    aes: 'monkeyhasbanana'
    bind: '172.18.0.64'

# The default packets to be installed.
# Salt will keep them at latest version.
  default_pkgs:
    - vim-enahnced
    - sudo

# OP5, Zabbix servers:
  monitor:
    servers:
      - '172.18.0.64'
