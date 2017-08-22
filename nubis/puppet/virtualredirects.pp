# Virtual Redirects

nubis::static { 'redirect-san.mozilla.org':
    servername  => 'redirect-san.mozilla.org',
    rewrites             => [
        {
            rewrite_rule => ['^/?(.*) https://%{HTTP_HOST}/$1 [L,R=307,QSA]'],
        },
    ]
}
