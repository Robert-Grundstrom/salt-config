server:
  settings:

# Network configuration:
    network:
      ens3:
        set_type: single
        set_ipaddr: 172.18.0.50
        set_netmask: 255.255.255.0
        set_gateway: 172.18.0.254

# DNS search and servers:
    set_dns:
      - set_search: blacknet.lan
      - set_server:
        - 172.18.0.254

# NTP servers:
    set_ntp:
      - ntp1.sth.netnod.se
      - ntp2.sth.netnod.se

# If enabled sets a harder configuration for
# the SSH deamon service.
    ssh_config:
      - source:
        - 172.18.0.0/24
      - interface: ens3

# Firewall settings:
    firewall:
      - enable: False
      - rules:
        - 'TCP,4505,172.18.0.0/24'
        - 'TCP,4506,172.18.0.0/24'

# SNMP settings:
    set_snmp:
      - snmp_usr: rouser
      - snmp_sha: monkeylikebanana
      - snmp_aes: monkeyhasbanana
      - snmp_ip: 172.18.0.50

# The default packets to be installed.
# Salt will keep them at latest version.
    set_default_packets:
      - vim
      - network-manager
      - sudo

# For added security, uncomment the following lines
# and add the ip-addresses to your monitor server.
# (OP5, Zabbix servers.)
monitor:
  servers:
    - '172.18.0.60'
