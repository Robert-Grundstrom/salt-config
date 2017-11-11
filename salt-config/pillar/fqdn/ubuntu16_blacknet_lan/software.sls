software:
  inspircd:
    network:
      irc_bind_addr: '172.18.0.51'
      irc_port: '6667'
      irc_type: 'clients'
      irc_dns: '172.18.0.254'

    settings:
      irc_name: 'irc.local'
      irc_description: 'Local IRC Server'
      irc_network: 'Blacknet'

    admin:
      irc_name: 'IRC Administrator'
      irc_nick: 'ircadmin'
      irc_email: 'root@localhost'

# There are no default settings for the SSL configuration.
# The SSL options are requiered.
    ssl:
      country: 'SE'
      state: 'Bohuslan'
      city: 'Gothenburg'
      organisation: 'Private'
      unit: 'IT'

    operators:
      rgrundstrom:
        password: 'test'
        host: '*@172.18.0.10'
        type: 'NetAdmin'
