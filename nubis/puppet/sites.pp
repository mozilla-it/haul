$docroot = '/var/www/html'
$access_log_format = '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"'

$default_headers = [
  "set X-Nubis-Version ${project_version}",
  "set X-Nubis-Project ${project_name}",
  "set X-Nubis-Build   ${packer_build_name}",
  'set X-Content-Type-Options "nosniff"',
  'set X-XSS-Protection "1; mode=block"',
  'set X-Frame-Options "DENY"',
  'set Strict-Transport-Security "max-age=31536000"',
]

$final_rewrite = [
  {
    comment      => 'Proxy to our bucket',
    rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
    rewrite_rule => ["/(.*) \${sitemap:${title}}\$1 [P,L]"],
  }
]

$default_rewrites = [
]

$default_indexes = [
  'index.html',
  'index.htm',
]

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

nubis::static { 'archive':
  servername => 'website-archive.mozilla.org',
  serveraliases      => [
    'website-archive.allizom.org',
  ],
}

nubis::static { 'bugzilla':
  servername => 'www.bugzilla.org',
  serveraliases      => [
    'bugzilla.org',
    'bugzilla.org.uk',
    'www.bugzilla.org.uk',
    'virtual-bzorg.mozilla.org',
    'website-beta.bugzilla.org',
    'bugzilla.mozilla.osuosl.org',
  ],
}

nubis::static { 'tlscanary':
  servername => 'tlscanary.mozilla.org',
  serveraliases      => [
    'tlscanary.allizom.org',
  ],
}

nubis::static { 'nightly':
  servername => 'nightly.mozilla.org',
  serveraliases      => [
    'nightly.allizom.org',
  ],
}

nubis::static { 'publicsuffix':
  servername => 'www.publicsuffix.org',
  serveraliases      => [
    'publicsuffix.org',
  ],
}

nubis::static { 'services':
  servername => 'docs.services.mozilla.com',
}

nubis::static { 'sso':
  servername => 'sso.mozilla.com',
}

nubis::static { 'trackertest':
  servername => 'trackertest.org',
  serveraliases      => [
    'itsatracker.org',
    'itsatracker.com',
  ],
}

nubis::static { 'seamonkey':
  servername => 'www.seamonkey-project.org',
  serveraliases      => [
    'www-stage.seamonkey-project.org',
    'seamonkey-project.org',
  ],
}

nubis::static { 'krakenbenchmark':
  servername => 'krakenbenchmark.mozilla.org',
}
