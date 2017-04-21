define nubis::static ($servername, $serveraliases=[], $indexes=[], $headers=[], $rewrites=[]) {
  apache::vhost { $title:
    port               => $port,
    servername         => $servername,
    serveraliases      => $serveraliases,

    docroot            => "/data/haul/$title",

    directoryindex     => join(concat($indexes, $default_indexes), " "),

    setenvif           => [
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var => '!internal',
    access_log_format  => $access_log_format,

    headers            => concat($default_headers, "set X-Nubis-Site $title", $headers),
    rewrites           => concat($default_rewrites, $rewrites),
  }
}