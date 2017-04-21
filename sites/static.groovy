@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
        checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', locations: [[credentialsId: '', depthOption: 'infinity', ignoreExternalsOption: true, local: 'src', remote: 'https://svn.mozilla.org/projects/static.mozilla.com/trunk']], workspaceUpdater: [$class: 'UpdateUpdater']])
   nubisStatic.prepSite()
   }
   
  stage ('Build') {
    nubisStatic.buildSite()
  }
    
  stage('Sync') {
     nubisStatic.syncSite()
  }
}
