nubis::static { 'example':
  servername => 'example.mozilla.org',
  serveraliases => [
    'example.allizom.org',
  ],
}

nubis::static { 'static':
  servername => 'static.mozilla.com',
}

nubis::static { 'archive':
  servername    => 'website-archive.mozilla.org',
  serveraliases => [
    'website-archive.allizom.org',
  ],
}

nubis::static { 'bugzilla':
  servername    => 'www.bugzilla.org',
  serveraliases => [
    'bugzilla.org',
    'bugzilla.org.uk',
    'www.bugzilla.org.uk',
    'virtual-bzorg.mozilla.org',
    'website-beta.bugzilla.org',
    'bugzilla.mozilla.osuosl.org',
  ],
}

nubis::static { 'tlscanary':
  servername    => 'tlscanary.mozilla.org',
  serveraliases => [
    'tlscanary.allizom.org',
  ],
}

nubis::static { 'nightly':
  servername    => 'nightly.mozilla.org',
  serveraliases => [
    'nightly.allizom.org',
  ],
}

nubis::static { 'publicsuffix':
  servername    => 'www.publicsuffix.org',
  serveraliases => [
    'publicsuffix.org',
  ],
}

nubis::static { 'services':
  servername => 'docs.services.mozilla.com',
}

nubis::static { 'sso':
  servername => 'sso.mozilla.com',
}

nubis::static { 'trackertest':
  servername    => 'trackertest.org',
  serveraliases => [
    'itsatracker.org',
    'itsatracker.com',
  ],
}

nubis::static { 'seamonkey':
  servername    => 'www.seamonkey-project.org',
  serveraliases => [
    'www-stage.seamonkey-project.org',
    'seamonkey-project.org',
  ],
}

nubis::static { 'krakenbenchmark':
  servername => 'krakenbenchmark.mozilla.org',
}
