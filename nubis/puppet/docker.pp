class { 'docker':
  proxy => "http://proxy.service.consul:3128/",
  bip   => "172.17.42.1/16",
}

file { '/etc/dnsmasq.d/docker.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'interface=docker0',
}

file { '/etc/network/interfaces.d/dns.cfg':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'append domain-name-servers 172.17.42.1',
}
