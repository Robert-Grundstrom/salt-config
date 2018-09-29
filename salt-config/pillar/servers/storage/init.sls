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
    search: blacknet.lan
    servers:
      - '172.18.0.254'

        # NTP servers:
  ntp:
    config: client
    servers:
      - ntp1.sth.netnod.se
      - ntp2.sth.netnod.se

        # SSHD Options:
  ssh:
#    source: '172.18.0.0/24'
    bind: '172.18.0.200'

  # Firewall settings:
  firewall:
    enable: True
    rules:
    # For ProFTPd
      - 'TCP,21,0.0.0.0/0'
      - 'TCP,20,0.0.0.0/0'
      - 'TCP,30000:50000,0.0.0.0/0'

    # For Ubuntu repo
      - 'TCP,80,172.18.0.0/24'

    # For NFS 
      - 'TCP,111,172.18.0.0/24'
      - 'TCP,2049,172.18.0.0/24'
      - 'TCP,111,10.0.10.2/29'
      - 'TCP,2049,10.0.10.2/29'

    # For samba
      - 'UDP,137,172.18.0.0/24'
      - 'UDP,138,172.18.0.0/24'
      - 'TCP,139,172.18.0.0/24'
      - 'TCP,445,172.18.0.0/24'
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
