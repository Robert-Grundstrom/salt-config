software:
  inspircd:
    network:
      irc_bind_addr: '172.18.0.51'
      irc_port: '6667'
      irc_type: 'clients'
      irc_dns:
        - '172.18.0.254'

    settings:
      irc_name: 'irc.local'
      irc_description: 'Local IRC Server'
      irc_network: 'Blacknet'

    irc_admin:
      irc_name:'IRC Administrator':
      irc_nick: 'ircadmin'
      irc_email: 'root@localhost' 
