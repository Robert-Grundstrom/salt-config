software:

# Network configuration:
  network:
    enp4s0:
      set_type: 'single'
      set_ipaddr: '172.18.0.200'
      set_netmask: '255.255.255.0'
      set_gateway: '172.18.0.254'

        # DNS search and servers:
  dns:
    - set_search: blacknet.lan
    - set_server:
        - 172.18.0.254

        # NTP servers:
  ntp:
    - ntp1.sth.netnod.se
    - ntp2.sth.netnod.se

        # SSHD Options:
  ssh:
    - source: '172.18.0.0/24'
    - interface: 'enp4s0'

  # Firewall settings:
  firewall:
    - enable: False
    - rules:
        - 'TCP,21,172.18.0.254/32'
        - 'TCP,21,172.18.0.10/32'
        - 'TCP,9987,0.0.0.0/0'
        - 'TCP,80,172.18.0.0/24'

  # SNMP settings:
  snmp:
    user: rouser
    sha: monkeylikebanana
    aes: monkeyhasbanana
    bind: 172.18.0.200

  # The default packets to be installed.
  # Salt will keep them at latest version.
  default_pkgs:
    - vim
    - sudo

  # OP5, Zabbix servers:
  monitor:
    servers:
      - '172.18.0.60'
