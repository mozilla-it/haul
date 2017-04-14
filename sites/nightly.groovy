@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
        checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla/nocturnal.git']]])   
   nubisStatic.prepSite()
   }
   
  stage ('Build') {
    docker.image('python:2.7').inside('-e HTTPS_PROXY=http://proxy.service.consul:3128/ -e HTTP_PROXY=http://proxy.service.consul:3128/')  {
      sh "python src/scrape.py --output-dir=src/"
    }
    sh "rsync -a --delete --cvs-exclude src/ dst/"
  }
    
  stage('Sync') {
     nubisStatic.syncSite()
  }
}
