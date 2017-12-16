software:
  inspircd:

# Network configuration.
    network:
      irc_bind_addr: '172.18.0.51'
      irc_port: '6667'
      irc_type: 'clients'
      irc_dns: '172.18.0.254'

# IRC name, description, network.
    settings:
      irc_name: 'irc.local'
      irc_description: 'Local IRC Server'
      irc_network: 'Blacknet'

# Administrator user.
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

# Operators, the users that are specified here kan use the /OPER
# command to gain global OP on the IRC server.
    operators:
      rgrundstrom:
        password: 'test'
        host: '*@*'
        type: 'NetAdmin'
