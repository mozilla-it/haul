package { 'daemon':
  ensure => 'present'
}->
class { 'jenkins':
  # Direct download because something in apt-land is borked with varnish ;-(
  direct_download    => 'https://pkg.jenkins.io/debian-stable/binary/jenkins_2.46.1_all.deb',
  repo               => false,
  version            => 'latest',
  configure_firewall => false,
  service_enable     => false,
  service_ensure     => 'stopped',
  config_hash        => {
    'JAVA_ARGS' => {
      'value' => '-Djava.awt.headless=true -Dhudson.diyChunking=false -Dhttp.proxyHost=proxy.service.consul -Dhttp.proxyPort=3128 -Dhttps.proxyHost=proxy.service.consul -Dhttps.proxyPort=3128'
    },
  },
}

package { 'awscli':
  ensure => latest,
}
