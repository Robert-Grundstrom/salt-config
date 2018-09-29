base:
# For all servers but OpenBSD.
  '* not G@os:OpenBSD':
    
    - configuration.salt-repository
    - configuration.network
    - configuration.users.administrator
    - configuration.call_home
    - software.firewall
    - software.common_pkgs

# General for OpenBSD.
  'G@os:OpenBSD':
    - software.sudo
    - software.ntp
    - roles.groups.administrator

  'G@os:CentOS':
    - configuration.centos-repo

# Individual servers.
  'storage.blacknet.lan':
    - software.nfs-server
    - software.pxeboot

  'bible-black':
    - software.squid
