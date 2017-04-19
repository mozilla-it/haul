class {'varnish':
  varnish_listen_port => 82,
  storage_type          => 'file',
  varnish_storage_size  => '80%',
  cookiekeeps => [
    'JSESSIONID[^=]*',
    'jenkins[^=]*',
  ],
  logrealip => true,
  honor_backend_ttl => true,
  x_forwarded_proto => true,
  cond_requests => true,
}

class { 'varnish::vcl':
  # Send to Apache
  backends          => {
    'default' => {
      host => '127.0.0.1',
      port => '81'
    },
  },

  # More options
  logrealip         => true,
  honor_backend_ttl => true,
  cond_requests     => true,
}
