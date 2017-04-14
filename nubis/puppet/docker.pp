class { 'docker':
  proxy => "http://proxy.service.consul:3128/",
  bip   => "172.17.42.1/16",
  requires => [
    Class['jenkins'],
  ]
}

file { '/etc/dnsmasq.d/docker.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'interface=docker0',
}
