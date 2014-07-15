define windows::downloadable_package(
  $url,
  $install_options = [],
) {
  include windows::params

  $filename = regsubst($url, '.*/([^/]+)$', '\1')

  pget { "Download $name":
    source => $url,
    target => $windows::params::downloadsdir,
  } ->
  package { $name:
    ensure          => installed,
    source          => "${windows::params::downloadsdir}\\${filename}",
    install_options => $install_options,
  }
}
