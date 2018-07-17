@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla-itcloud/mozqa.com.git']]])
            checkout([$class: 'GitSCM', branches: [[name: '*/gh-pages']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/qa-testcase-data/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla/qa-testcase-data.git']]])	    
            checkout([$class: 'GitSCM', branches: [[name: '*/gh-pages']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/webapi-permissions-tests/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/jds2501/webapi-permissions-tests.git']]])
	    checkout([$class: 'MercurialSCM', clean: true, credentialsId: '', source: 'https://hg.mozilla.org/qa/testcase-data', subdir: 'src/data'])
	    //mozmill-env missing
   }
   
  stage ('Build') {
    nubisStatic.buildSite()
  }
    
  stage('Sync') {
     nubisStatic.syncSite()
  }
}
