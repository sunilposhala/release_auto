# metricbeat::install
class metricbeat::install inherits metricbeat {
  $metricbeat_install_path = '/etc/metricbeat'
  case $facts['osfamily'] {
    'Ubuntu': {
        $metricbeat_download_url     = 'https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.1.1-amd64.deb'
        $metricbeat_package_file     = 'metricbeat-6.1.1-amd64.deb'
        $metricbeat_package_provider = 'dpkg'
      }
    'RedHat': {
        $metricbeat_download_url     = 'https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.1.1-x86_64.rpm'
        $metricbeat_package_provider = 'rpm'
        $metricbeat_package_file     = 'metricbeat-6.1.1-x86_64.rpm'
      }
    default:{}
  }

  if $metricbeat::ensure == 'present' {
    $package_ensure = $metricbeat::package_ensure
  }
  else {
    $package_ensure = $metricbeat::ensure
  }
  archive { "/opt/metricbeat/${metricbeat_package_file}":
    ensure  => present,
    source  => $metricbeat_download_url,
    creates => "${metricbeat_install_path}/6.1.1",
    require => File['/opt/metricbeat'],
  }
  package{'metricbeat':
    ensure   => latest,
    provider => $metricbeat_package_provider,
    source   => "/opt/metricbeat/${metricbeat_package_file}",
    require  => Archive["/opt/metricbeat/${metricbeat_package_file}"],
  }

  file { ['/opt/metricbeat', $metricbeat_install_path]:
    ensure => directory,
  }
  file {'/etc/metricbeat/metricbeat.yml':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/metricbeat/metricbeat.yml',
    notify => Service['metricbeat'],
  }
}
