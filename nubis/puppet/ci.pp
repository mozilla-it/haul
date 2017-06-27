python::pip { 'awscli':
  ensure  => '1.11.78',
}

package { 'mercurial':
  ensure => latest,
}

file { '/var/lib/jenkins/.hgrc':
  ensure => file,
  owner  => 'jenkins',
  group  => 'jenkins',
  mode   => '0644',
  require => [
    Class['jenkins'],
  ],
  source => 'puppet:///nubis/files/hgrc',
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
      'value' => '--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT --prefix=$PREFIX'
    },
    'JAVA_ARGS' => {
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
  ensure => directory,
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
  ensure => '1.1'
}

jenkins::plugin { 'ant':
  ensure => '1.5'
}

jenkins::plugin { 'antisamy-markup-formatter':
  ensure => '1.5'
}

jenkins::plugin { 'authentication-tokens':
  ensure => '1.3'
}

jenkins::plugin { 'authorize-project':
  ensure => '1.3.0'
}

jenkins::plugin { 'bouncycastle-api':
  ensure => '2.16.1'
}

jenkins::plugin { 'branch-api':
  ensure => '2.0.10'
}

jenkins::plugin { 'build-timeout':
  ensure => '1.18'
}

jenkins::plugin { 'cloudbees-folder':
  ensure => '6.0.4'
}

jenkins::plugin { 'credentials-binding':
  ensure => '1.12'
}

jenkins::plugin { 'display-url-api':
  ensure => '2.0'
}

jenkins::plugin { 'docker-commons':
  ensure => '1.7'
}

jenkins::plugin { 'docker-workflow':
  ensure => '1.12'
}

jenkins::plugin { 'durable-task':
  ensure => '1.14'
}

jenkins::plugin { 'email-ext':
  ensure => '2.57.2'
}

jenkins::plugin { 'envinject':
  ensure => '2.1.1'
}

jenkins::plugin { 'external-monitor-job':
  ensure => '1.7'
}

jenkins::plugin { 'git':
  ensure => '3.3.1'
}

jenkins::plugin { 'git-client':
  ensure => '2.4.6'
}

jenkins::plugin { 'git-server':
  ensure => '1.7'
}

jenkins::plugin { 'github':
  ensure => '1.27.0'
}

jenkins::plugin { 'github-api':
  ensure => '1.85.1'
}

jenkins::plugin { 'github-branch-source':
  ensure => '2.0.6'
}

jenkins::plugin { 'github-organization-folder':
  ensure => '1.6'
}

jenkins::plugin { 'gradle':
  ensure => '1.27-SNAPSHOT (private-06/23/2017 09:49-wolf)'
}

jenkins::plugin { 'handlebars':
  ensure => '1.1.1'
}

jenkins::plugin { 'icon-shim':
  ensure => '2.0.3'
}

jenkins::plugin { 'jackson2-api':
  ensure => '2.7.3'
}

jenkins::plugin { 'job-dsl':
  ensure => '1.63'
}

jenkins::plugin { 'jquery-detached':
  ensure => '1.2.1'
}

jenkins::plugin { 'junit':
  ensure => '1.20'
}

jenkins::plugin { 'ldap':
  ensure => '1.15'
}

jenkins::plugin { 'mailer':
  ensure => '1.20'
}

jenkins::plugin { 'mapdb-api':
  ensure => '1.0.9.0'
}

jenkins::plugin { 'matrix-auth':
  ensure => '1.6'
}

jenkins::plugin { 'matrix-project':
  ensure => '1.11'
}

jenkins::plugin { 'mercurial':
  ensure => '1.61'
}

jenkins::plugin { 'momentjs':
  ensure => '1.1.1'
}

jenkins::plugin { 'pam-auth':
  ensure => '1.3'
}

jenkins::plugin { 'pipeline-build-step':
  ensure => '2.5'
}

jenkins::plugin { 'pipeline-github-lib':
  ensure => '1.0'
}

jenkins::plugin { 'pipeline-graph-analysis':
  ensure => '1.4'
}

jenkins::plugin { 'pipeline-input-step':
  ensure => '2.7'
}

jenkins::plugin { 'pipeline-milestone-step':
  ensure => '1.3.1'
}

jenkins::plugin { 'pipeline-model-api':
  ensure => '1.1.7'
}

jenkins::plugin { 'pipeline-model-declarative-agent':
  ensure => '1.1.1'
}

jenkins::plugin { 'pipeline-model-definition':
  ensure => '1.1.7'
}

jenkins::plugin { 'pipeline-model-extensions':
  ensure => '1.1.7'
}

jenkins::plugin { 'pipeline-rest-api':
  ensure => '2.8'
}

jenkins::plugin { 'pipeline-stage-step':
  ensure => '2.2'
}

jenkins::plugin { 'pipeline-stage-tags-metadata':
  ensure => '1.1.7'
}

jenkins::plugin { 'pipeline-stage-view':
  ensure => '2.8'
}

jenkins::plugin { 'plain-credentials':
  ensure => '1.4'
}

jenkins::plugin { 'resource-disposer':
  ensure => '0.6'
}

jenkins::plugin { 'scm-api':
  ensure => '2.1.1'
}

jenkins::plugin { 'script-security':
  ensure => '1.29'
}

jenkins::plugin { 'ssh-credentials':
  ensure => '1.13'
}

jenkins::plugin { 'ssh-slaves':
  ensure => '1.20'
}

jenkins::plugin { 'structs':
  ensure => '1.9'
}

jenkins::plugin { 'subversion':
  ensure => '2.8'
}

jenkins::plugin { 'timestamper':
  ensure => '1.8.8'
}

jenkins::plugin { 'token-macro':
  ensure => '2.1'
}

jenkins::plugin { 'windows-slaves':
  ensure => '1.3.1'
}

jenkins::plugin { 'workflow-aggregator':
  ensure => '2.5'
}

jenkins::plugin { 'workflow-api':
  ensure => '2.17'
}

jenkins::plugin { 'workflow-basic-steps':
  ensure => '2.5'
}

jenkins::plugin { 'workflow-cps':
  ensure => '2.36'
}

jenkins::plugin { 'workflow-cps-global-lib':
  ensure => '2.8'
}

jenkins::plugin { 'workflow-durable-task-step':
  ensure => '2.12'
}

jenkins::plugin { 'workflow-job':
  ensure => '2.11.1'
}

jenkins::plugin { 'workflow-multibranch':
  ensure => '2.16'
}

jenkins::plugin { 'workflow-scm-step':
  ensure => '2.5'
}

jenkins::plugin { 'workflow-step-api':
  ensure => '2.11'
}

jenkins::plugin { 'workflow-support':
  ensure => '2.14'
}

jenkins::plugin { 'ws-cleanup':
  ensure => '0.33'
}
