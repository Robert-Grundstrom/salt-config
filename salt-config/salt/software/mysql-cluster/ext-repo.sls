# Adds Percona repositorys to servers.
---

{%-if salt['grains.get']('os') in ['CentOS', 'RedHat']%}
mysql-repo:
  pkgrepo.managed:
    - names:
      - 'percona-release':
        - humanname: 'Percona-Release YUM repository - $basearch'
        - baseurl: 'http://repo.percona.com/release/$releasever/RPMS/$basearch'

      - 'percona-release-noarch':
        - humanname: 'Percona-Release YUM repository - $basearch'
        - baseurl: 'http://repo.percona.com/release/$releasever/RPMS/noarch'

      - 'percona-release-source':
        - humanname: 'Percona-Release YUM repository - $basearch'
        - baseurl: 'http://repo.percona.com/release/$releasever/SRPMS'

    - gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Percona'
    - gpgcheck: 1
    - enable: 1
    - file: '/etc/yum.repos.d/percona-release.repo'
{%endif%}
