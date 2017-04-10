file { '/etc/nubis.d/0-consul-advertise':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/consul-advertise',
}
