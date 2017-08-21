@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
     nubisStatic.prepSite()
   }

  stage ('Build') {
    // Symlink destination
    sh "ln -sf ../dst src/dest"
    docker.image('dhartnell/mozilla-planet-builder:latest').inside('-u 0:0 -e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY') {
      sh "apt update"
      sh "apt install -y rsync"
      sh "/usr/local/bin/planet-prod.sh"
      sh "rsync -aq --exclude=.git /data/genericrhel6/src/ dest/planet-sites/"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
     // Cleanup symlink
     sh "rm -f src/dest"
  }

}
