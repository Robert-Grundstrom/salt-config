base:
# For all servers but OpenBSD.
  '* not G@os:OpenBSD':
    - configuration.old-common
    - software.firewall-base
    - roles.groups.administrator
    - software
    - software.firewall-base
    - software.snmp
    - configuration.salt-repository

# General for OpenBSD.
  'G@os:OpenBSD':
    - software.sudo
    - software.ntp
    - roles.groups.administrator

# Individual servers.
  'storage.blacknet.lan':
    - software.nfs-server
    - software.pxeboot
