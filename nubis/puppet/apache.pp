#saptxt" Define how Apache should be installed and configured
# We should try to recycle the puppetlabs-apache puppet module in the future:
# https://github.com/puppetlabs/puppetlabs-apache
#

# Define how Apache should be installed and configured

class { 'nubis_apache':
  port      => $port,
  check_url => '/server-status?auto',
}

class { 'apache::mod::rewrite': }
class { 'apache::mod::proxy': }
class { 'apache::mod::proxy_http': }

apache::custom_config { 'proxyremote':
    content       => 'ProxyRemoteMatch "\.amazonaws\.com/" http://proxy.service.consul:3128',
    verify_config => false,
}

apache::custom_config { 'proxyerror':
    content       => 'ProxyErrorOverride On',
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
    port            => $port,
    docroot         => '/var/www/html',

    access_log_file => '/dev/null',

    rewrites        => [
      {
        comment      => 'Proxy to Jenkins',
        rewrite_rule => ['/jenkins/(.*) http://localhost:8080/jenkins/$1 [P,L]'],
      }
    ]
}
