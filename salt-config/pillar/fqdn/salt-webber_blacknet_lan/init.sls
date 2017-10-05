server:
  settings:
    network:
      ens3:
        set_type: single
        set_ipaddr: 172.18.0.54
        set_netmask: 255.255.255.0
        set_gateway: 172.18.0.254

# Custom iptables rules for this server.
# Syntax is protocol,port,source/prefix
    fw_enable: True
    firewall:
      - rules:
        - 'TCP,80,172.18.0.0/24'
        - 'TCP,443,172.18.0.0/24'
        - 'TCP,3306,172.18.0.0/24'
