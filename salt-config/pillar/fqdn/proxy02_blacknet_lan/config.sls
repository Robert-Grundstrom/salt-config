server:
  settings:

# Network configuration:
    network:
      ens3:
        set_type: 'single'
        set_ipaddr: '172.18.0.52'
        set_netmask: '255.255.255.0'
        set_gateway: '172.18.0.254'

        # DNS search and servers:
    set_dns:
      - set_search: blacknet.lan
      - set_server:
          - 172.18.0.254

        # NTP servers:
    set_ntp:
      - ntp1.sth.netnod.se
      - ntp2.sth.netnod.se

        # SSHD Options:
    ssh_config:
      - source: '172.18.0.0/24'
      - interface: 'ens3'

        # Firewall settings:
    firewall:
      - enable: False
#      - rules:

        # SNMP settings:
    set_snmp:
      - snmp_usr: rouser
      - snmp_sha: monkeylikebanana
      - snmp_aes: monkeyhasbanana
      - snmp_ip: 172.18.0.51

        # The default packets to be installed.
        # Salt will keep them at latest version.
    set_default_packets:
      - vim
      - sudo

        # OP5, Zabbix servers:
    monitor:
      servers:
        - '172.18.0.60'