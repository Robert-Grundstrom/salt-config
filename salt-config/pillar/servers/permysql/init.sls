software:
# Network configuration
  network:
    ens160:
      set_type: 'single'
      set_ipaddr: '172.18.0.102'
      set_netmask: '255.255.255.0'
      set_gateway: '172.18.0.254'

  # DNS search and servers
  dns:
    search: blacknet.lan
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
    - interface: 'ens160'

# SNMP settings:
  snmp:
    user: rouser
    sha: monkeylikebanana
    aes: monkeyhasbanana
    bind: '172.18.0.102'

# The default packets to be installed.
# Salt will keep them at latest version.
  default_pkgs:
    - vim
    - sudo

# OP5, Zabbix servers:
  monitor:
    servers:
      - '172.18.0.60'

  # Firewall settings:
  firewall:
    enable: True
    rules:
    # For Rundeck mysql.
      - 'TCP,3306,172.18.0.101/32'
      - 'TCP,3306,172.18.0.241/32'
