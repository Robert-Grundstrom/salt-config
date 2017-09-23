server:
  settings:
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


{%if salt['grains.get']('os') == "Ubuntu"%}
    set_default_packets:
      - vim
      - network-manager
      - sudo
{%endif%}

{%if salt['grains.get']('os') == "CentOS"%}
    set_default_packets:
      - NetworkManager
      - vim-enhanced
      - sudo
{%endif%}
