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
    docker.image('dhartnell/mozilla-planet-builder:2.0').inside('-u 0:0 -e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY') {
      sh "/usr/local/bin/planet-prod.sh"
      sh "cp -r /data/genericrhel6/src/planet.firefox.com/* dst/"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }

}
