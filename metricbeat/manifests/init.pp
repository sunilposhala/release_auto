# metricbeat
class{'metricbeat':
  contain metricbeat::install
  contain metricbeat::config
  contain metricbeat::service

  -> Class['::foobar::install']
  -> Class['::foobar::config']
  ~> Class['::foobar::service']
}
