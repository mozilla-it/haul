define nubis::static (
  $servername,
  $serveradmin=undef,
  $serveraliases=[],
  $indexes=[],
  $headers=[],
  $options=[],
  $redirectmatch_status=[],
  $redirectmatch_regexp=[],
  $redirectmatch_dest=[],
  $rewrites=[],
  $custom_fragment=undef,
  $directories=undef,
  $use_default_headers=true) {

  apache::vhost { $title:
    port                 => $port,
    serveradmin          => $serveradmin,
    servername           => $servername,
    serveraliases        => $serveraliases,

    options              => $options,

    redirectmatch_status => $redirectmatch_status,
    redirectmatch_regexp => $redirectmatch_regexp,
    redirectmatch_dest   => $redirectmatch_dest,

    docroot              => "/data/haul/${title}",

    directoryindex       => join(concat($indexes, $default_indexes), ' '),

    directories          => $directories,

    setenvif             => [
      'X_FORWARDED_PROTO https HTTPS=on',
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var   => '!internal',
    access_log_format    => $access_log_format,

    if use_default_headers {
      headers => concat($default_headers, "set X-Nubis-Site ${title}", $headers),
    }
    elsif {
      headers => concat("set X-Nubis-Site ${title}", $headers),
    }

    rewrites             => concat($default_rewrites, $rewrites),

    custom_fragment      => $custom_fragment,
  }

}
