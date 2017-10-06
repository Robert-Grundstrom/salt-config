# This is a template to use with servers.
# This configuration should be in the folder that 
# matches your FQDN were dots are replaced with "_"
# and should be named init.sls
#
# Example: salt-master_foo_bar_com/init.sls
#
# Copy this file to folder of your server and edit accordingly.

# Any OPTIONAL options that is not set in this file will default
# to the values that is commented in this file.

server:
  settings:

# Network configuration (REQUIRED):
    network:
      ens3:
        set_type: single
        set_ipaddr: 192.168.0.2
        set_netmask: 255.255.255.0
        set_gateway: 192.168.0.1

# DNS search and servers (REQUIRED):
    set_dns:
      - set_search: foo.bar.com
      - set_server:
        - 192.168.0.100
        - 192.168.0.200

# NTP servers (OPTIONAL):
#    set_ntp:
#      - ntp1.sth.netnod.se
#      - ntp2.sth.netnod.se

# If enabled sets a harder configuration for
# the SSH deamon service (OPTIONAL).
#    hardned_ssh:
#      - enable: False
#      - source: 0.0.0.0/0
#      - interface: (ALL)

# SNMP settings (OPTIONAL):
#    set_snmp:
#      - snmp_usr: rouser
#      - snmp_sha: monkeylikebanana
#      - snmp_aes: monkeyhasbanana
#      - snmp_ip: 0.0.0.0

# The default packets to be installed.
# Salt will keep them at latest version.
#    set_default_packets:
#      - (NONE)

# For added security, uncomment the following lines
# and add the ip-addresses to your monitor server.
# (OP5, Zabbix servers.)
#monitor:
#  servers:
#    - '0.0.0.0/0'

# Firewall settings (OPTIONAL):
#    firewall:
#      - enable: False
#
# You can set extra firewall options here
# the syntax is protocol,port,source/prefix
# in the example below we will set the ports
# requiered by the salt-master.
#      - rules:
#        - 'TCP,4505,172.18.0.0/24'
#        - 'TCP,4506,172.18.0.0/24'
