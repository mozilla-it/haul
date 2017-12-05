@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla/www.ccadb.org.git']]])
   }

  stage ('Build') {
    docker.image('ruby:2.4').inside('-e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY') {
      sh "set -x"
      sh "cd src"
      sh "pwd"
      sh "bundler install"
      sh "jekyll --version"
      sh "jekyll build --verbose  -d ../dst"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }
}
