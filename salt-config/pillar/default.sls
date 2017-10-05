server:
  settings:
    set_dns:
      - set_search: blacknet.lan
      - set_server:
        - 172.18.0.254

    set_ntp:
      - ntp1.sth.netnod.se
      - ntp2.sth.netnod.se

    hardned_ssh:
      - enable: False
      - source: 0.0.0.0/0
#      - interface: ens3  

# By default firewall is set to Disable.
# Salt will still write the rules. But
# policy will be accept for all incoming chains.
    fw_enable: False

# As a default value snmp_ip should be commented out.
# But if set_snmp.* is in fqdn.<hostname> folder you
# can set it to the interface you desire.
    set_snmp:
      - snmp_usr: rouser
      - snmp_sha: monkeylikebanana
      - snmp_aes: monkeyhasbanana
      - snmp_ip: 0.0.0.0

# Ubuntu and Debian packages.
{%if salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
    set_default_packets:
      - vim
      - network-manager
      - sudo
{%endif%}

# CentOS and Redhat packages.
{%-if salt['grains.get']('os') in ['CentOS', 'Redhat']%}
    set_default_packets:
      - NetworkManager
      - vim-enhanced
      - sudo
{%endif%}
