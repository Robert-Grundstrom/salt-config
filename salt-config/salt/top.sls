base:
# For all servers but OpenBSD.
  '* not G@os:OpenBSD':
    - common
    - software.firewall-base
    - roles.groups.administrator
    - software.ntp
    - software.firewall-base
    - software.snmp
    - software.sshd
    - software.sudo

# General for OpenBSD.
  'G@os:OpenBSD':
    - software.sudo
    - software.ntp
    - roles.groups.administrator

# Individual servers.
  'storage.blacknet.lan':
    - software.nfs-server
    - software.pxeboot
