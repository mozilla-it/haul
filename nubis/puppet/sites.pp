$docroot = '/var/www/html'
$access_log_format = '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"'

apache::vhost { 'tlscanary':
  port               => $port,
  servername         => 'tlscanary.mozilla.org',
  serveraliases      => [
    'tlscanary.allizom.org',
  ],

  docroot            => $docroot,

  setenvif           => [
    'Remote_Addr 127\.0\.0\.1 internal',
    'Remote_Addr ^10\. internal',
  ],

  access_log_env_var => '!internal',
  access_log_format  => $access_log_format,

  headers            => [
    "set X-Nubis-Version ${project_version}",
    "set X-Nubis-Project ${project_name}",
    "set X-Nubis-Build   ${packer_build_name}",
  ],

  rewrites           => [
    {
      comment      => 'Proxy to our bucket',
      rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
      rewrite_rule => ['/(.*) ${sitemap:tlscanary} [P,L]'],
    }
  ]
}

apache::vhost { 'nightly':
  port               => $port,
  servername         => 'nightly.mozilla.org',

  docroot            => $docroot,

  setenvif           => [
    'Remote_Addr 127\.0\.0\.1 internal',
    'Remote_Addr ^10\. internal',
  ],
  access_log_env_var => '!internal',
  access_log_format  => $access_log_format,

  headers            => [
    "set X-Nubis-Version ${project_version}",
    "set X-Nubis-Project ${project_name}",
    "set X-Nubis-Build   ${packer_build_name}",
  ],
  rewrites           => [
      {
         comment      => 'Proxy to our bucket',
         rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
         rewrite_rule => ['/(.*) ${sitemap:nightly} [P,L]'],
      }
  ]
}

apache::vhost { 'archive':
  port               => $port,
  servername         => 'website-archive.mozilla.org',

  docroot            => $docroot,

  setenvif           => [
    'Remote_Addr 127\.0\.0\.1 internal',
    'Remote_Addr ^10\. internal',
  ],
  access_log_env_var => '!internal',
  access_log_format  => $access_log_format,

  headers            => [
    "set X-Nubis-Version ${project_version}",
    "set X-Nubis-Project ${project_name}",
    "set X-Nubis-Build   ${packer_build_name}",
  ],
  rewrites           => [
      {
         comment      => 'Proxy to our bucket',
         rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
         rewrite_rule => ['/(.*) ${sitemap:archive} [P,L]'],
      }
  ]
}

apache::vhost { 'trackertest':
  port               => $port,
  servername         => 'trackertest.org',
  serveraliases      => [
    'itsatracker.org',
    'itsatracker.com',
  ],

  docroot            => $docroot,

  setenvif           => [
    'Remote_Addr 127\.0\.0\.1 internal',
    'Remote_Addr ^10\. internal',
  ],
  access_log_env_var => '!internal',
  access_log_format  => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',

  headers            => [
    "set X-Nubis-Version ${project_version}",
    "set X-Nubis-Project ${project_name}",
    "set X-Nubis-Build   ${packer_build_name}",
  ],
  rewrites           => [
      {
         comment      => 'Proxy to our bucket',
         rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
         rewrite_rule => ['/(.*) ${sitemap:trackertest} [P,L]'],
      }
  ]
}
