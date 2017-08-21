nubis::static { 'static':
  servername  => 'static.mozilla.com',
  serveraliases => [
    'static-haul.allizom.org',
  ]
}

nubis::static { 'planet':
  servername    => 'planet.mozilla.org',
  serveraliases => [
    'planet.allizom.org',
  ]
}

nubis::static { 'start':
  servername           => 'start.mozilla.org',
  serveraliases        => [
    'start.allizom.org',
    'start-haul.allizom.org',
  ],
  rewrites             => [
    {
      # RedirectMatch ^/$ http://start.mozilla.org/en-US/
      redirectmatch_status => ['302'],
      redirectmatch_regexp => ['^/$'],
      redirectmatch_dest   => ['http://start-haul.allizom.org/en-US/'],
    },
  ]

}

nubis::static { 'archive':
  servername    => 'website-archive.mozilla.org',
  serveraliases => [
    'website-archive.allizom.org',
    'website-archive-haul.allizom.org',
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
    'bugzilla-haul.allizom.org',
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
    'nightly-haul.allizom.org',
  ],
}

nubis::static { 'publicsuffix':
  servername    => 'www.publicsuffix.org',
  serveraliases => [
    'publicsuffix.org',
    'publicsuffix-haul.allizom.org',
  ],
}

nubis::static { 'services':
  servername    => 'docs.services.mozilla.com',
  serveraliases => [
    'docs-haul-services.allizom.org',
  ]
}

nubis::static { 'sso':
  servername    => 'sso.mozilla.com',
  serveraliases => [
    'sso-haul.allizom.org',
  ]
}

nubis::static { 'trackertest':
  servername    => 'trackertest.org',
  serveraliases => [
    'itsatracker.org',
    'itsatracker.com',
    'itisatracker-haul.allizom.org',
  ],
}

nubis::static { 'seamonkey':
  servername    => 'www.seamonkey-project.org',
  serveraliases => [
    'www-stage.seamonkey-project.org',
    'seamonkey-project.org',
    'seamonkey-project-haul.allizom.org',
  ],
}

nubis::static { 'krakenbenchmark':
  servername    => 'krakenbenchmark.mozilla.org',
  serveraliases => [
    'krakenbenchmark.allizom.org',
  ]
}
