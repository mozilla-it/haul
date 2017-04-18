#saptxt" Define how Apache should be installed and configured
# We should try to recycle the puppetlabs-apache puppet module in the future:
# https://github.com/puppetlabs/puppetlabs-apache
#

# Define how Apache should be installed and configured

class { 'nubis_apache':
  port      => 81,
  check_url => '/server-status?auto',
}

class { 'apache::mod::rewrite': }
class { 'apache::mod::proxy': }
class { 'apache::mod::proxy_http': }

apache::custom_config { 'proxyremote':
    content       => 'ProxyRemote * http://proxy.service.consul:3128',
    verify_config => false,
}

file { '/etc/haul':
  ensure  => directory,

  owner   => 'root',
  group   => 'root',
  mode    => '0755',

  require => [
    Class['Nubis_apache']
  ],
}

# For monitoring to have someone to talk to
apache::vhost { 'localhost':
    priority        => 0,
    port            => 81,
    default_vhost   => true,
    docroot         => '/var/www/html',

    access_log_file => '/dev/null',
}

apache::vhost { 'tlscanary':
    port               => 81,
    servername         => 'tlscanary.mozilla.org',
    serveraliases      => [
      'tlscanary.allizom.org',
    ],

    docroot            => '/var/www/html',

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
           rewrite_rule => ['/(.*) ${sitemap:tlscanary} [P,L]'],
        }
    ]

}

apache::vhost { 'nightly':
    port               => 81,
    servername         => 'nightly.mozilla.org',

    docroot            => '/var/www/html',

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
           rewrite_rule => ['/(.*) ${sitemap:nightly} [P,L]'],
        }
    ]
}

apache::vhost { 'archive':
    port               => 81,
    servername         => 'website-archive.mozilla.org',

    docroot            => '/var/www/html',

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
           rewrite_rule => ['/(.*) ${sitemap:archive} [P,L]'],
        }
    ]
}

apache::vhost { 'trackertest':
    port               => 81,
    servername         => 'trackertest.org',
    serveraliases      => [
      'itsatracker.org',
      'itsatracker.com',
    ],

    docroot            => '/var/www/html',

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
