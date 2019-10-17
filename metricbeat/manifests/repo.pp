# metricbeat::repo
# @api private
#
# If included, configure the relevant repo manager on the target node.
#
# @summary Manages the relevant repo manager on the target node.
class metricbeat::repo inherits metricbeat {
  case $facts['osfamily'] {
    'Debian': {
      include ::apt

      if !defined(Apt::Source['beats']) {
        apt::source{'beats':
          location => 'https://artifacts.elastic.co/packages/5.x/apt',
          release  => 'stable',
          repos    => 'main',
          key      => {
            id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
            source => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          },
        }
      }
    }
    'RedHat': {
      if !defined(Yumrepo['beats']) {
        yumrepo{'beats':
          descr    => 'Elastic repository for 5.x packages',
          baseurl  => 'https://artifacts.elastic.co/packages/5.x/yum',
          gpgcheck => 1,
          gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          enabled  => 1,
        }
      }
    }
    'SuSe': {
      exec { 'topbeat_suse_import_gpg':
        command => '/usr/bin/rpmkeys --import https://artifacts.elastic.co/GPG-KEY-elasticsearch',
        unless  => '/usr/bin/test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
        notify  => [ Zypprepo['beats'] ],
      }
      if !defined (Zypprepo['beats']) {
        zypprepo{'beats':
          baseurl     => 'https://artifacts.elastic.co/packages/5.x/yum',
          enabled     => 1,
          autorefresh => 1,
          name        => 'beats',
          gpgcheck    => 1,
          gpgkey      => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          type        => 'yum',
        }
      }
    }
    default: {
    }
  }
}
