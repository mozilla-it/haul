$port = 81
$docroot = '/var/www/html'
$access_log_format = '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"'

$default_headers = [
  "set X-Nubis-Version ${project_version}",
  "set X-Nubis-Project ${project_name}",
  "set X-Nubis-Build   ${packer_build_name}",
  'set X-Content-Type-Options "nosniff"',
  'set X-XSS-Protection "1; mode=block"',
  'set X-Frame-Options "DENY"',
  'set Strict-Transport-Security "max-age=31536000"',
]

$final_rewrite = [
  {
    comment      => 'Proxy to our bucket',
    rewrite_map  => [ 'sitemap txt:/etc/haul/sitemap.txt' ],
    rewrite_rule => ["/(.*) \${sitemap:${title}}\$1 [P,L]"],
  }
]

$default_rewrites = [
]

$default_indexes = [
  'index.html',
  'index.htm',
]