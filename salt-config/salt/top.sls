base:
  '* not G@os:OpenBSD':
  - common
  - roles.groups.administrator
  - software.ntp
  - software.firewall
  - software.snmp
  - software.sshd
  - software.sudo

  'G@os:OpenBSD':
  - software.sudo
  - software.ntp
  - roles.groups.administrator
