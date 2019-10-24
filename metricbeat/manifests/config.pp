# metricbeat::config
class metricbeat::config (
  Tuple[Hash] $modules                                                = [{}],
  Hash $outputs                                                       = {},
  String $beat_name                                                   = $::hostname,
  Boolean $disable_configtest                                         = false,
  Enum['present', 'absent'] $ensure                                   = 'present',
  Optional[Hash] $fields                                              = undef,
  Boolean $fields_under_root                                          = false,
  Hash $logging                                                       = {
    'level'     => 'info',
    'files'     => {
      'keepfiles'        => 7,
      'name'             => 'metricbeat',
      'path'             => '/var/log/metricbeat',
      'rotateeverybytes' => '10485760',
    },
    'metrics'   => {
      'enabled' => false,
      'period'  => '30s',
    },
    'selectors' => undef,
    'to_files'  => true,
    'to_syslog' => false,
  },
  Boolean $manage_repo                                                = true,
  String $package_ensure                                              = 'present',
  Optional[Tuple[Hash]] $processors                                   = undef,
  Integer $queue_size                                                 = 1000,
  Enum['enabled', 'disabled', 'running', 'unmanaged'] $service_ensure = 'enabled',
  Boolean $service_has_restart                                        = true,
  Optional[Array[String]] $tags                                       = undef,
) {
  $validate_cmd      = disable_configtest ? {
    true    => undef,
    default => '/usr/share/metricbeat/bin/metricbeat -configtest -c %',
  }
  $metricbeat_config = delete_undef_values({
    'name'              => beat_name,
    'fields'            => fields,
    'fields_under_root' => fields_under_root,
    'tags'              => tags,
    'queue_size'        => queue_size,
    'logging'           => logging,
    'processors'        => processors,
    'metricbeat'        => {
    'modules'         => modules,
  },
    'output'            => outputs,
  })
}
