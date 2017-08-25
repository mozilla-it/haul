@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
     // Do you have to call checkout in order to setup the src directory?
     checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla/planet-source.git']]])
   nubisStatic.prepSite()
   }

  stage ('Build') {
    // Symlink destination
    docker.image('dhartnell/mozilla-planet-builder:latest').inside('-u 0:0 -e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY') {
      sh "apt update"
      sh "apt install -y rsync"
      sh "/usr/local/bin/planet-prod.sh"
      sh "rsync -aq --exclude=.git /data/genericrhel6/src/ dst/"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }

}
