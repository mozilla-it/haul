$docroot = '/var/www/html'
$access_log_format = '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"'

apache::vhost { 'archive':
  port               => $port,
  servername         => 'website-archive.mozilla.org',
  serveraliases      => [
    'website-archive.allizom.org',
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
         rewrite_rule => ['/(.*) ${sitemap:archive}$1 [P,L]'],
      }
  ]
}

apache::vhost { 'bugzilla':
  port               => $port,
  servername         => 'www.bugzilla.org',
  serveraliases      => [
    'bugzilla.org',
    'bugzilla.org.uk',
    'www.bugzilla.org.uk',
    'virtual-bzorg.mozilla.org',
    'website-beta.bugzilla.org',
    'bugzilla.mozilla.osuosl.org',
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

    #Bug 1317833 Observatory
    'set X-Content-Type-Options "nosniff"',
    'set X-XSS-Protection "1; mode=block"',
    'set X-Frame-Options "DENY"',
    'set Strict-Transport-Security "max-age=31536000"',
  ],
  rewrites           => [
      {
         comment      => 'Proxy to our bucket',
         rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
         rewrite_rule => ['/(.*) ${sitemap:bugzilla}$1 [P,L]'],
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
         rewrite_rule => ['/(.*) ${sitemap:nightly}$1 [P,L]'],
      }
  ]
}

apache::vhost { 'publicsuffix':
  port               => $port,
  servername         => 'www.publicsuffix.org',
  serveraliases      => [
    'publicsuffix.org',
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
         rewrite_rule => ['/(.*) ${sitemap:publicsuffix}$1 [P,L]'],
      }
  ]
}

apache::vhost { 'services':
  port               => $port,
  servername         => 'www.publicsuffix.org',
  serveraliases      => [
    'publicsuffix.org',
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
         rewrite_rule => ['/(.*) ${sitemap:services}$1 [P,L]'],
      }
  ]
}

apache::vhost { 'sso':
  port               => $port,
  servername         => 'sso.mozilla.com',

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
         rewrite_rule => ['/(.*) ${sitemap:sso}$1 [P,L]'],
      }
  ]
}

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

    #Bug 1317833 Observatory
    'set X-Content-Type-Options "nosniff"',
    'set X-XSS-Protection "1; mode=block"',
    'set X-Frame-Options "DENY"',
    'set Strict-Transport-Security "max-age=31536000"',
  ],

  rewrites           => [
    {
      comment      => 'Proxy to our bucket',
      rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
      rewrite_rule => ['/(.*) ${sitemap:tlscanary}$1 [P,L]'],
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
         rewrite_rule => ['/(.*) ${sitemap:trackertest}$1 [P,L]'],
      }
  ]
}

apache::vhost { 'seamonkey':
  port               => $port,
  servername         => 'www.seamonkey-project.org',
  serveraliases      => [
    'www-stage.seamonkey-project.org',
    'seamonkey-project.org',
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
    "set X-Nubis-Site    ${title}",
  ],
  rewrites           => [
      {
         comment      => 'Proxy to our bucket',
         rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
         rewrite_rule => ["/(.*) \${sitemap:${title}}\$1 [P,L]"],
      }
  ]
}
