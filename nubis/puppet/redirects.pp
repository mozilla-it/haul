# Redirect sites

#nubis::static { 'redirect-san.mozilla.org':
#    servername  => 'redirect-san.mozilla.org',
#    rewrites             => [
#        {
#            rewrite_rule => ['^/?(.*) https://%{HTTP_HOST}/$1 [L,R=307,QSA]'],
#        },
#    ]
#}
#

file { "$::apache::confd_dir/redirects.conf":
    owner => root,
    group => www-data,
    mode => '0750',
    source => "puppet:///nubis/files/redirects.conf",
    before => Custom_config['redirects'],
}

apache::custom_config { 'redirects':
    content       => "Include $::apache::confd_dir/redirects.conf",
    verify_config => false,
}
