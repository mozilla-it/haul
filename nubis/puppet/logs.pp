fluentd::configfile { 'traefik': }

fluentd::source { 'traefik-access':
  configfile  => 'traefik',
  type        => 'tail',
  format      => 'json',
  time_format => '%Y-%m-%dT%H:%M:%SZ',
  tag         => 'forward.traefik.access',
  config      => {
    'read_from_head' => true,
    'path'           => '/var/log/traefik.log',
    'pos_file'       => '/var/log/traefik.pos',
  },
}

fluentd::source { 'traefik-error':
  configfile  => 'traefik',
  type        => 'tail',
  format      => 'json',
  time_format => '%Y-%m-%dT%H:%M:%SZ',
  tag         => 'forward.traefik.error',
  config      => {
    'read_from_head' => true,
    'path'           => '/var/log/traefik_error.log',
    'pos_file'       => '/var/log/traefik_error.pos',
  },
}
