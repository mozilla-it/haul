@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/joshmarinacci/jsconfeu-builder.git']]])
    nubisStatic.prepSite()
   }

  stage ('Build') {
    docker.image('node:9').inside('-e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY')  {
      sh "rm -f build"
      sh "cd src && npm install"
      sh "ln -sf ../dst build"
      sh "cd src && npm run build"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }
}


