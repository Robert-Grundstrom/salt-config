base:
# For all servers but OpenBSD.
  '* not G@os:OpenBSD':
    
    - configuration.salt-repository
    - configuration.network
    - configuration.users.administrator
    - configuration.call_home
    - software.firewall-base
    - software.common_pkgs

# General for OpenBSD.
  'G@os:OpenBSD':
    - software.sudo
    - software.ntp
    - roles.groups.administrator

# Individual servers.
  'storage.blacknet.lan':
    - software.nfs-server
    - software.pxeboot
