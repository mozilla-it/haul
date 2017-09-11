@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
  stage('Prep') {
    nubisStatic.prepSite()
  }

  stage ('Build') {
    docker.image('dhartnell/mozilla-planet-builder:4.2').inside("-u 0:0 -e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY -v /data/haul/${env.JOB_NAME}/planet-cache/:/data/efs/") {
      sh "/usr/local/bin/planet-prod.sh planet"
      sh "rsync -aq /data/genericrhel6/src/planet.mozilla.org/* dst/"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }

}
