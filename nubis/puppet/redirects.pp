# Redirect sites

file { "$::apache::confd_dir/redirects.conf":
    owner => root,
    group => www-data,
    mode => '0750',
    source => "puppet:///nubis/files/redirects.conf",
} -> apache::custom_config { 'redirects':
    content       => "Include $::apache::confd_dir/redirects.conf",
    verify_config => false,
}
