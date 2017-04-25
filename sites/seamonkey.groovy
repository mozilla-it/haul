@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
     checkout([$class: 'MercurialSCM', clean: true, credentialsId: '', source: 'https://hg.mozilla.org/SeaMonkey/seamonkey-project-org', subdir: 'src'])

     nubisStatic.prepSite()
   }

  stage ('Build') {
    // Symlink destination
    sh "ln -sf ../dst src/dest"
    docker.image('perl:5.22').inside('-u 0:0 -e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY') {
      sh "apt-get update"
      sh "apt-get -y install rsync xmlto"
      sh "cpanm --notest Template@2.27 Template::Plugin::XML@2.17"
      sh "cd src && /usr/local/bin/ttree -v -f etc/ttree.cfg"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
     // Cleanup symlink
     sh "rm -f src/dest"
  }

}
