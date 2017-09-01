fluentd::configfile { 'traefik': }

fluentd::source { 'traefik_error':
  configfile => 'traefik',
  type       => 'tail',
  format     => 'none',
  tag        => 'forward.traefik.error',
  config     => {
    'path'     => '/var/log/upstart/traefik.log',
    'pos_file' => '/var/log/upstart/traefik.log.pos',
  },
}
