@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/bugzilla/bugzilla.org.git']]])
   nubisStatic.prepSite()
   }

  stage ('Build') {
    // Symlink destination
    sh "ln -sf ../dst src/dest"
    docker.image('perl:5.22').inside('-u 0:0') {
      sh "apt-get update"
      sh "apt-get -y install rsync xmlto texlive-lang-cyrillic lynx"
      sh "cd src/files && cpanm --notest --installdeps ."
      sh "cd src && /usr/local/bin/ttree -v -f etc/ttree.cfg"
      sh "cd src && /usr/local/bin/ttree -v -f etc/ttree-docs.cfg"
      sh "cd src && rsync -aq --exclude=.git --exclude=/*.html src/docs/ dest/docs/"
      sh "cd src && perl -pi -e's/git.mozilla.org/github.com/g' bin/build-docs.pl"
      sh "cd src && /usr/local/bin/perl bin/build-docs.pl"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
     // Cleanup symlink
     sh "rm -f src/dest"
  }

}
