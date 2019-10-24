# metricbeat
class metricbeat{
  contain metricbeat::install
  contain metricbeat::config
  contain metricbeat::service

  -> Class['::metricbeat::install']
  -> Class['::metricbeat::config']
  ~> Class['::metricbeat::service']
}
