@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {

   // goes to src/
   stage('Prep') {
        checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla-it/nubis-static-website-example.git']]])

   // mkdir dst/
   nubisStatic.prepSite()
   }

  stage ('Build') {
    // rsync src/ dst/
    nubisStatic.buildSite()
  }

  // pull from dst/
  stage('Sync') {
     nubisStatic.syncSite()
  }
}
