@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
        checkout([$class: 'MercurialSCM', clean: true, credentialsId: '', source: 'https://hg.mozilla.org/projects/kraken', subdir: 'src'])
   nubisStatic.prepSite()
   }
   
  stage ('Build') {
    docker.image('python:2.7').inside()  {
      sh "cd src && python make-hosted.py"
    }
    sh "rsync -a --delete --cvs-exclude src/hosted/ dst/"
  }
    
  stage('Sync') {
     nubisStatic.syncSite()
  }
}
