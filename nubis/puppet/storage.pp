include nubis_storage

nubis::storage { $project_name:
  type    => 'efs',
  owner   => 'jenkins',
  group   => 'jenkins',
  require => [
    Class['jenkins'],
  ]
}
