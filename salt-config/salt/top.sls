base:
# For all servers but OpenBSD.
  '* not G@os:OpenBSD':
    - configuration.salt-repository
    - configuration.network
    - software.firewall-base
    - software.common_pkgs
    - software.firewall-base
    - roles.groups.administrator

# General for OpenBSD.
  'G@os:OpenBSD':
    - software.sudo
    - software.ntp
    - roles.groups.administrator

# Individual servers.
  'storage.blacknet.lan':
    - software.nfs-server
    - software.pxeboot
