package { 'daemon':
  ensure => 'present'
}->
class { 'jenkins':
  version            => '2.46.1',
  configure_firewall => false,
  service_enable     => false,
  service_ensure     => 'stopped',
  config_hash        => {
    'JAVA_ARGS' => {
      'value' => '-Djava.awt.headless=true -Dhudson.diyChunking=false -Dhttp.proxyHost=proxy.service.consul -Dhttp.proxyPort=3128 -Dhttps.proxyHost=proxy.service.consul -Dhttps.proxyPort=3128'
    },
  },
}
