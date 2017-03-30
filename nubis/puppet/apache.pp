# Define how Apache should be installed and configured
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

file { '/etc/apache2/haul':
  ensure => directory,
  
  owner   => 'root',
  group   => 'root',
  mode    => '0755',

  require => [
    Class['Nubis_apache']
  ],
}

# For monitoring to have someone to talk to
apache::vhost { 'localhost':
    priority      => 0,
    port          => 81,
    default_vhost => true,
    docroot       => '/var/www/html',
}

apache::vhost { 'tlscanary':
    port                  => 81,
    servername            => 'tlscanary.mozilla.org',

    docroot               => '/var/www/html',

    additional_includes   => [
      '/etc/apache2/haul/tlscanary.conf',
    ],

    setenvif              => [
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var    => '!internal',
    access_log_format     => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',

    headers               => [
      "set X-Nubis-Version ${project_version}",
      "set X-Nubis-Project ${project_name}",
      "set X-Nubis-Build   ${packer_build_name}",
    ],
    
}

apache::vhost { 'nightly':
    port                  => 81,
    servername            => 'nightly.mozilla.org',

    docroot               => '/var/www/html',

    additional_includes   => [
      '/etc/apache2/haul/nightly.conf',
    ],

    setenvif              => [
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var    => '!internal',
    access_log_format     => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',

    headers               => [
      "set X-Nubis-Version ${project_version}",
      "set X-Nubis-Project ${project_name}",
      "set X-Nubis-Build   ${packer_build_name}",
    ], 
}

apache::vhost { 'archive':
    port                  => 81,
    servername            => 'website-archive.mozilla.org',

    docroot               => '/var/www/html',

    additional_includes   => [
      '/etc/apache2/haul/archive.conf',
    ],

    setenvif              => [
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var    => '!internal',
    access_log_format     => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',

    headers               => [
      "set X-Nubis-Version ${project_version}",
      "set X-Nubis-Project ${project_name}",
      "set X-Nubis-Build   ${packer_build_name}",
    ], 
}
