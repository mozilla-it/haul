# Redirect sites

# Make the Apache config file for redirects
file { "${::apache::confd_dir}/redirects.conf":
    owner  => root,
    group  => www-data,
    mode   => '0644',
    source => 'puppet:///nubis/files/redirects.conf',
} -> apache::custom_config { 'redirects':   # And include it in the main Apache config
    content       => "Include ${::apache::confd_dir}/redirects.conf",
    verify_config => false,
}
