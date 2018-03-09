include nubis_discovery

nubis::discovery::service { 'varnish':
  tcp      => 'localhost:6082',
  interval => '15s',
}

class {'varnish':
  version              => '4.1',
  varnish_listen_port  => 82,
  storage_type         => 'file',
  varnish_storage_size => '1G',
  varnish_storage_file => '/mnt/varnish_storage.bin',
}

class { 'varnish::vcl':
  # Send to Apache
  backends               => {
    'default' => {
      host => '127.0.0.1',
      port => '81'
    },
  },

  # Don't scrub headers
  unset_headers          => [ ],
  unset_headers_debugips => [ ],

  # More options
  cookiekeeps            => [
    'JSESSIONID[^=]*',
    'jenkins[^=]*',
  ],

  logrealip              => true,
  honor_backend_ttl      => true,
  x_forwarded_proto      => true,
  cond_requests          => true,
}

$varnish_exporter_version = '1.3.4'
$varnish_exporter_url = "https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/${varnish_exporter_version}/prometheus_varnish_exporter-${varnish_exporter_version}.linux-amd64.tar.gz"

notice ("Grabbing varnish_exporter ${varnish_exporter_version}")
staging::file { "varnish_exporter.${varnish_exporter_version}.tar.gz":
  source => $varnish_exporter_url,
}
  -> staging::extract { "varnish_exporter.${varnish_exporter_version}.tar.gz":
  target  => '/usr/local/bin',
  strip   => 1,
  creates => '/usr/local/bin/prometheus_varnish_exporter',
}

systemd::unit_file { 'varnish_exporter.service':
  source => 'puppet:///nubis/files/varnish_exporter.systemd',
}
  -> service { 'varnish_exporter':
  ensure => 'stopped',
  enable => true,
}
