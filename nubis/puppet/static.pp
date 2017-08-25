define nubis::static (
  $servername,
  $serveraliases=[],
  $indexes=[],
  $headers=[],
  $options=[],
  $redirectmatch_status=[],
  $redirectmatch_regexp=[],
  $redirectmatch_dest=[],
  $rewrites=[]) {

  apache::vhost { $title:
    port                    => $port,
    servername              => $servername,
    serveraliases           => $serveraliases,

    options                 => $options,

    redirectmatch_status    => $redirectmatch_status,
    redirectmatch_regexp    => $redirectmatch_regexp,
    redirectmatch_dest      => $redirectmatch_dest,

    docroot                 => "/data/haul/${title}",

    directoryindex          => join(concat($indexes, $default_indexes), ' '),

    setenvif                => [
      'X_FORWARDED_PROTO https HTTPS=on',
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var      => '!internal',
    access_log_format       => $access_log_format,

    headers                 => concat($default_headers, "set X-Nubis-Site ${title}", $headers),
    rewrites                => concat($default_rewrites, $rewrites),
  }

}
