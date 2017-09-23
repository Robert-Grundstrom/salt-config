server:
  settings:
    network:
      ens3:
        set_type: single
        set_ipaddress: 172.18.0.54
        set_netmask: 255.255.255.0
        set_gateway: 172.18.0.254

    set_dns:
      set_search: blacknet.lan

      set_server:
        - 172.18.0.254
   
    set_ntp:
     - ntp1.sth.netnod.se
     - ntp2.sth.netnod.se

    set_snmp_settings:
      - set_snmp_user: rouser
      - set_sha_passwd: monkeylikebanana
      - set_aes_passwd: monkeyhasbanana
      - set_ipaddr: {{salt['network.ip_addrs']()|first}}

    set_default_packets:
      - vim
      - network-manager
      - sudo
