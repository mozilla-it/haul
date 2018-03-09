$jenkins_version = '2.89.4'

python::pip { 'awscli':
  ensure  => '1.11.78',
}

package { 'mercurial':
  ensure => latest,
}

file { '/var/lib/jenkins/.hgrc':
  ensure  => file,
  owner   => 'jenkins',
  group   => 'jenkins',
  mode    => '0644',
  require => [
    Class['jenkins'],
  ],
  source  => 'puppet:///nubis/files/hgrc',
}

file { '/etc/nubis.d/99-jenkins':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/jenkins-startup',
}

package { 'daemon':
  ensure => 'present'
}
  -> class { 'jenkins':
  # Direct download because something in apt-land is borked with varnish ;-(
  direct_download    => "https://pkg.jenkins.io/debian-stable/binary/jenkins_${jenkins_version}_all.deb",
  repo               => false,
  configure_firewall => false,
  service_enable     => false,
  service_ensure     => 'stopped',
  install_java       => true,
  config_hash        => {
    'JENKINS_ARGS' => {
      'value' => '--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT --requestHeaderSize=16384 --prefix=/admin/haul-admin-$(nubis-metadata NUBIS_ENVIRONMENT)'
    },
    'JAVA_ARGS'    => {
      'value' => '-Djenkins.install.runSetupWizard=false -Djava.awt.headless=true -Dhudson.diyChunking=false -Dhttp.proxyHost=proxy.service.consul -Dhttp.proxyPort=3128 -Dhttps.proxyHost=proxy.service.consul -Dhttps.proxyPort=3128'
    },
  },
}

# Jenkins is already defining the user for this, so cheat
exec { 'jenkins-docker-group':
  command => '/usr/sbin/usermod -G docker jenkins',
  require => [
    Class['jenkins'],
    Class['docker'],
  ],
}

file { '/var/lib/jenkins/init.groovy.d':
  ensure  => directory,
  owner   => 'jenkins',
  group   => 'jenkins',

  require => [
    Class['jenkins'],
  ],
}

file { '/var/lib/jenkins/init.groovy.d/security.groovy':
  ensure  => present,
  owner   => 'jenkins',
  group   => 'jenkins',

  source  => 'puppet:///nubis/files/security.groovy',

  require => [
    File['/var/lib/jenkins/init.groovy.d'],
  ],
}

file { '/var/lib/jenkins/jenkins.security.QueueItemAuthenticatorConfiguration.xml':
  ensure  => present,
  owner   => 'jenkins',
  group   => 'jenkins',

  source  => 'puppet:///nubis/files/jenkins.security.QueueItemAuthenticatorConfiguration.xml',

  require => [
    Class['jenkins'],
  ],
}

file { '/var/lib/jenkins/jenkins.CLI.xml':
  ensure  => present,
  owner   => 'jenkins',
  group   => 'jenkins',

  source  => 'puppet:///nubis/files/jenkins.CLI.xml',

  require => [
    Class['jenkins'],
  ],
}

file { '/var/lib/jenkins/config.xml':
  ensure  => present,
  owner   => 'jenkins',
  group   => 'jenkins',

  source  => 'puppet:///nubis/files/jenkins.xml',

  require => [
    Class['jenkins'],
  ],
}

file { '/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml':
  ensure  => present,
  owner   => 'jenkins',
  group   => 'jenkins',

  source  => 'puppet:///nubis/files/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml',

  require => [
    Class['jenkins'],
  ],
}

file { '/var/lib/jenkins/jobs/00-haul':
  ensure  => directory,
  owner   => 'jenkins',
  group   => 'jenkins',

  require => [
    Class['jenkins'],
  ],
}

file { '/var/lib/jenkins/jobs/00-haul/config.xml':
  ensure  => present,
  owner   => 'jenkins',
  group   => 'jenkins',

  source  => 'puppet:///nubis/files/haul.xml',

  require => [
    File['/var/lib/jenkins/jobs/00-haul'],
  ],
}
