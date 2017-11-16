define nubis::static (
  $servername,
  $serveradmin=undef,
  $serveraliases=[],
  $indexes=[],
  $headers=[],
  $options=[],
  $override=[],
  $redirectmatch_status=[],
  $redirectmatch_regexp=[],
  $redirectmatch_dest=[],
  $rewrites=[],
  $aliases=[],
  $custom_fragment=undef,
  $directories=undef,
  $error_documents=undef,
  $use_default_headers=true) {

  if $use_default_headers {
    $all_headers = concat($default_headers, ["set X-Nubis-Site ${title}"], $headers)
  } else {
    $all_headers = concat(["set X-Nubis-Site ${title}"], $headers)
  }

  apache::vhost { $title:
    port                 => $port,
    serveradmin          => $serveradmin,
    servername           => $servername,
    serveraliases        => $serveraliases,

    options              => $options,

    redirectmatch_status => $redirectmatch_status,
    redirectmatch_regexp => $redirectmatch_regexp,
    redirectmatch_dest   => $redirectmatch_dest,

    docroot              => "/data/${project_name}/${title}",

    directoryindex       => join(concat($indexes, $default_indexes), ' '),

    directories          => $directories,

    setenvif             => [
      'X_FORWARDED_PROTO https HTTPS=on',
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var   => '!internal',
    access_log_format    => $access_log_format,

    headers              => $all_headers,

    aliases              => $aliases,

    rewrites             => concat($default_rewrites, $rewrites),

    error_documents      => $error_documents,

    custom_fragment      => $custom_fragment,

    override             => $override,
  }

}
