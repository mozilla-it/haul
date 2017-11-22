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
}->
class { 'jenkins':
  # Direct download because something in apt-land is borked with varnish ;-(
  direct_download    => 'https://pkg.jenkins.io/debian-stable/binary/jenkins_2.46.2_all.deb',
  repo               => false,
  version            => 'latest',
  configure_firewall => false,
  service_enable     => false,
  service_ensure     => 'stopped',
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

jenkins::plugin { 'ace-editor':
  version => '1.1'
}

jenkins::plugin { 'ant':
  version => '1.5'
}

jenkins::plugin { 'antisamy-markup-formatter':
  version => '1.5'
}

jenkins::plugin { 'authentication-tokens':
  version => '1.3'
}

jenkins::plugin { 'authorize-project':
  version => '1.3.0'
}

jenkins::plugin { 'bouncycastle-api':
  version => '2.16.2'
}

jenkins::plugin { 'branch-api':
  version => '2.0.11'
}

jenkins::plugin { 'build-timeout':
  version => '1.18'
}

jenkins::plugin { 'cloudbees-folder':
  version => '6.1.0'
}

jenkins::plugin { 'credentials-binding':
  version => '1.12'
}

jenkins::plugin { 'display-url-api':
  version => '2.0'
}

jenkins::plugin { 'docker-commons':
  version => '1.8'
}

jenkins::plugin { 'docker-workflow':
  version => '1.12'
}

jenkins::plugin { 'durable-task':
  version => '1.14'
}

jenkins::plugin { 'email-ext':
  version => '2.58'
}

jenkins::plugin { 'envinject':
  version => '2.1.3'
}

jenkins::plugin { 'envinject-api':
  version => '1.2'
}

jenkins::plugin { 'external-monitor-job':
  version => '1.7'
}

jenkins::plugin { 'git':
  version => '3.5.0'
}

jenkins::plugin { 'git-client':
  version => '2.5.0'
}

jenkins::plugin { 'git-server':
  version => '1.7'
}

jenkins::plugin { 'github':
  version => '1.27.0'
}

jenkins::plugin { 'github-api':
  version => '1.86'
}

jenkins::plugin { 'github-branch-source':
  version => '2.2.3'
}

jenkins::plugin { 'github-organization-folder':
  version => '1.6'
}

jenkins::plugin { 'gradle':
  version => '1.27.1'
}

jenkins::plugin { 'handlebars':
  version => '1.1.1'
}

jenkins::plugin { 'icon-shim':
  version => '2.0.3'
}

jenkins::plugin { 'jackson2-api':
  version => '2.7.3'
}

jenkins::plugin { 'job-dsl':
  version => '1.64'
}

jenkins::plugin { 'jquery-detached':
  version => '1.2.1'
}

jenkins::plugin { 'junit':
  version => '1.20'
}

jenkins::plugin { 'ldap':
  version => '1.16'
}

jenkins::plugin { 'mailer':
  version => '1.20'
}

jenkins::plugin { 'mapdb-api':
  version => '1.0.9.0'
}

jenkins::plugin { 'matrix-auth':
  version => '1.7'
}

jenkins::plugin { 'matrix-project':
  version => '1.11'
}

jenkins::plugin { 'mercurial':
  version => '2.0'
}

jenkins::plugin { 'momentjs':
  version => '1.1.1'
}

jenkins::plugin { 'pam-auth':
  version => '1.3'
}

jenkins::plugin { 'pipeline-build-step':
  version => '2.5.1'
}

jenkins::plugin { 'pipeline-github-lib':
  version => '1.0'
}

jenkins::plugin { 'pipeline-graph-analysis':
  version => '1.4'
}

jenkins::plugin { 'pipeline-input-step':
  version => '2.7'
}

jenkins::plugin { 'pipeline-milestone-step':
  version => '1.3.1'
}

jenkins::plugin { 'pipeline-model-api':
  version => '1.1.9'
}

jenkins::plugin { 'pipeline-model-declarative-agent':
  version => '1.1.1'
}

jenkins::plugin { 'pipeline-model-definition':
  version => '1.1.9'
}

jenkins::plugin { 'pipeline-model-extensions':
  version => '1.1.9'
}

jenkins::plugin { 'pipeline-rest-api':
  version => '2.8'
}

jenkins::plugin { 'pipeline-stage-step':
  version => '2.2'
}

jenkins::plugin { 'pipeline-stage-tags-metadata':
  version => '1.1.9'
}

jenkins::plugin { 'pipeline-stage-view':
  version => '2.8'
}

jenkins::plugin { 'plain-credentials':
  version => '1.4'
}

jenkins::plugin { 'resource-disposer':
  version => '0.6'
}

jenkins::plugin { 'reverse-proxy-auth-plugin':
  version => '1.5'
}

jenkins::plugin { 'scm-api':
  version => '2.2.0'
}

jenkins::plugin { 'script-security':
  version => '1.30'
}

jenkins::plugin { 'ssh-credentials':
  version => '1.13'
}

jenkins::plugin { 'ssh-slaves':
  version => '1.20'
}

jenkins::plugin { 'structs':
  version => '1.9'
}

jenkins::plugin { 'subversion':
  version => '2.9'
}

jenkins::plugin { 'timestamper':
  version => '1.8.8'
}

jenkins::plugin { 'token-macro':
  version => '2.1'
}

jenkins::plugin { 'windows-slaves':
  version => '1.3.1'
}

jenkins::plugin { 'workflow-aggregator':
  version => '2.5'
}

jenkins::plugin { 'workflow-api':
  version => '2.19'
}

jenkins::plugin { 'workflow-basic-steps':
  version => '2.6'
}

jenkins::plugin { 'workflow-cps':
  version => '2.37'
}

jenkins::plugin { 'workflow-cps-global-lib':
  version => '2.8'
}

jenkins::plugin { 'workflow-durable-task-step':
  version => '2.13'
}

jenkins::plugin { 'workflow-job':
  version => '2.11.1'
}

jenkins::plugin { 'workflow-multibranch':
  version => '2.16'
}

jenkins::plugin { 'workflow-scm-step':
  version => '2.5'
}

jenkins::plugin { 'workflow-step-api':
  version => '2.12'
}

jenkins::plugin { 'workflow-support':
  version => '2.14'
}

jenkins::plugin { 'ws-cleanup':
  version => '0.34'
}
