package { 'awscli':
  ensure => latest,
}

package { 'daemon':
  ensure => 'present'
}->
class { 'jenkins':
  # Direct download because something in apt-land is borked with varnish ;-(
  direct_download    => 'https://pkg.jenkins.io/debian-stable/binary/jenkins_2.46.1_all.deb',
  repo               => false,
  version            => 'latest',
  configure_firewall => false,
  service_enable     => true,
  service_ensure     => 'stopped',
  config_hash        => {
    'JAVA_ARGS' => {
      'value' => '-Djava.awt.headless=true -Dhudson.diyChunking=false -Dhttp.proxyHost=proxy.service.consul -Dhttp.proxyPort=3128 -Dhttps.proxyHost=proxy.service.consul -Dhttps.proxyPort=3128'
    },
  },
}

jenkins::plugin { 'workflow-cps':
    version => '2.29'
}

jenkins::plugin { 'git-server':
    version => '1.7'
}

jenkins::plugin { 'bouncycastle-api':
    version => '2.16.1'
}

jenkins::plugin { 'windows-slaves':
    version => '1.3.1'
}

jenkins::plugin { 'antisamy-markup-formatter':
    version => '1.5'
}

jenkins::plugin { 'workflow-api':
    version => '2.13'
}

jenkins::plugin { 'pipeline-input-step':
    version => '2.5'
}

jenkins::plugin { 'github-api':
    version => '1.85'
}

jenkins::plugin { 'display-url-api':
    version => '2.0'
}

jenkins::plugin { 'script-security':
    version => '1.27'
}

jenkins::plugin { 'workflow-step-api':
    version => '2.9'
}

jenkins::plugin { 'ace-editor':
    version => '1.1'
}

jenkins::plugin { 'github':
    version => '1.27.0'
}

jenkins::plugin { 'workflow-support':
    version => '2.14'
}

jenkins::plugin { 'pipeline-model-declarative-agent':
    version => '1.1.1'
}

jenkins::plugin { 'junit':
    version => '1.20'
}

jenkins::plugin { 'matrix-auth':
    version => '1.5'
}

jenkins::plugin { 'github-organization-folder':
    version => '1.6'
}

jenkins::plugin { 'pipeline-rest-api':
    version => '2.6'
}

jenkins::plugin { 'email-ext':
    version => '2.57.2'
}

jenkins::plugin { 'github-branch-source':
    version => '2.0.5'
}

jenkins::plugin { 'workflow-basic-steps':
    version => '2.4'
}

jenkins::plugin { 'durable-task':
    version => '1.13'
}

jenkins::plugin { 'workflow-durable-task-step':
    version => '2.10'
}

jenkins::plugin { 'credentials-binding':
    version => '1.11'
}

jenkins::plugin { 'scm-api':
    version => '2.1.1'
}

jenkins::plugin { 'workflow-cps-global-lib':
    version => '2.7'
}

jenkins::plugin { 'timestamper':
    version => '1.8.8'
}

jenkins::plugin { 'pipeline-graph-analysis':
    version => '1.3'
}

jenkins::plugin { 'pipeline-model-extensions':
    version => '1.1.2'
}

jenkins::plugin { 'pipeline-milestone-step':
    version => '1.3.1'
}

jenkins::plugin { 'mailer':
    version => '1.20'
}

jenkins::plugin { 'pipeline-stage-step':
    version => '2.2'
}

jenkins::plugin { 'handlebars':
    version => '1.1.1'
}

jenkins::plugin { 'envinject':
    version => '2.0'
}

jenkins::plugin { 'pipeline-model-api':
    version => '1.1.2'
}

jenkins::plugin { 'ssh-slaves':
    version => '1.17'
}

jenkins::plugin { 'job-dsl':
    version => '1.61'
}

jenkins::plugin { 'build-timeout':
    version => '1.18'
}

jenkins::plugin { 'authentication-tokens':
    version => '1.3'
}

jenkins::plugin { 'gradle':
    version => '1.26'
}

jenkins::plugin { 'pam-auth':
    version => '1.3'
}

jenkins::plugin { 'mapdb-api':
    version => '1.0.9.0'
}

jenkins::plugin { 'ant':
    version => '1.4'
}

jenkins::plugin { 'workflow-aggregator':
    version => '2.5'
}

jenkins::plugin { 'ldap':
    version => '1.14'
}

jenkins::plugin { 'momentjs':
    version => '1.1.1'
}

jenkins::plugin { 'external-monitor-job':
    version => '1.7'
}

jenkins::plugin { 'jquery-detached':
    version => '1.2.1'
}

jenkins::plugin { 'branch-api':
    version => '2.0.8'
}

jenkins::plugin { 'workflow-scm-step':
    version => '2.4'
}

jenkins::plugin { 'workflow-multibranch':
    version => '2.14'
}

jenkins::plugin { 'subversion':
    version => '2.7.2'
}

jenkins::plugin { 'docker-commons':
    version => '1.6'
}

jenkins::plugin { 'matrix-project':
    version => '1.9'
}

jenkins::plugin { 'docker-workflow':
    version => '1.10'
}

jenkins::plugin { 'icon-shim':
    version => '2.0.3'
}

jenkins::plugin { 'pipeline-build-step':
    version => '2.5'
}

jenkins::plugin { 'ws-cleanup':
    version => '0.32'
}

jenkins::plugin { 'pipeline-github-lib':
    version => '1.0'
}

jenkins::plugin { 'resource-disposer':
    version => '0.6'
}

jenkins::plugin { 'git':
    version => '3.2.0'
}

jenkins::plugin { 'git-client':
    version => '2.4.1'
}

jenkins::plugin { 'plain-credentials':
    version => '1.4'
}

jenkins::plugin { 'structs':
    version => '1.6'
}

jenkins::plugin { 'pipeline-model-definition':
    version => '1.1.2'
}

jenkins::plugin { 'pipeline-stage-tags-metadata':
    version => '1.1.2'
}

jenkins::plugin { 'ssh-credentials':
    version => '1.13'
}

jenkins::plugin { 'workflow-job':
    version => '2.10'
}

jenkins::plugin { 'pipeline-stage-view':
    version => '2.6'
}

jenkins::plugin { 'token-macro':
    version => '2.1'
}

jenkins::plugin { 'cloudbees-folder':
    version => '6.0.3'
}
