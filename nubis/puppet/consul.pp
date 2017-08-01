file { '/etc/nubis.d/0-consul-advertise':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/consul-advertise',
}

file { '/etc/consul/svc-haul-admin.json':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0644',
  source => 'puppet:///nubis/files/svc-haul-admin.json',
}
