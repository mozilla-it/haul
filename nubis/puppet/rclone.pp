$rclone_version = "v1.36"
$rclone_url = "https://downloads.rclone.org/rclone-${rclone_version}-linux-amd64.zip"

notice ("Grabbing rclone ${rclone_version}")
staging::file { "rclone.${rclone_version}.zip":
  source => $rclone_url,
}->
staging::extract { "rclone.${rclone_version}.zip":
  strip   => 1,
  target  => '/usr/local/bin',
  creates => '/usr/local/bin/rclone'
}
