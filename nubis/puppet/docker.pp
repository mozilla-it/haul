class { 'docker':
  proxy => 'http://proxy.service.consul:3128/',
  bip   => '172.17.42.1/16',
}

file { '/etc/dnsmasq.d/docker.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'interface=docker0',
}

file { '/etc/resolvconf/resolv.conf.d/tail':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => "nameserver 172.17.42.1\n",
}

systemd::unit_file { 'docker-cleanup.service':
  source => 'puppet:///nubis/files/docker-cleanup.systemd',
}
