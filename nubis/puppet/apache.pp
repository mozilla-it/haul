#saptxt" Define how Apache should be installed and configured
# We should try to recycle the puppetlabs-apache puppet module in the future:
# https://github.com/puppetlabs/puppetlabs-apache
#

# Define how Apache should be installed and configured

class { 'nubis_apache':
  port      => $port,
  #tags      => [ '%%PURPOSE%%'],
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

apache::custom_config { 'negotiationmodule':
    content       => '
      AddLanguage ca .ca
      AddLanguage cs .cz .cs
      AddLanguage da .dk
      AddLanguage de .de
      AddLanguage el .el
      AddLanguage en .en
      AddLanguage eo .eo
      AddLanguage es .es
      AddLanguage et .et
      AddLanguage fr .fr
      AddLanguage he .he
      AddLanguage hr .hr
      AddLanguage it .it
      AddLanguage ja .ja
      AddLanguage ko .ko
      AddLanguage ltz .ltz
      AddLanguage nl .nl
      AddLanguage nn .nn
      AddLanguage no .no
      AddLanguage pl .po
      AddLanguage pt .pt
      AddLanguage pt-BR .pt-br
      AddLanguage ru .ru
      AddLanguage sv .sv
      AddLanguage zh-CN .zh-cn
      AddLanguage zh-TW .zh-tw
      LanguagePriority en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv zh-CN zh-TW',
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
        rewrite_rule => ['/admin/haul-admin/(.*) http://localhost:8080/admin/haul-admin/$1 [P,L]'],
      }
    ]
}
