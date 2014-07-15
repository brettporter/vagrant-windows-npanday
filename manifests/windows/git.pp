class windows::git(
  $version = '1.9.4-preview20140611',
) {

  windows::downloadable_package { "Git version ${version}":
    url             => "https://github.com/msysgit/msysgit/releases/download/Git-${version}/Git-${version}.exe",
    install_options => ['/VERYSILENT'],
  }
}

