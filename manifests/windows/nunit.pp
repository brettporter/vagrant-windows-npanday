class windows::nunit(
  $version = '2.6.3',
  $add_path = true,
) {
  windows::downloadable_package { "NUnit ${version}":
    url => "http://launchpad.net/nunitv2/trunk/${version}/+download/NUnit-${version}.msi",
  }
  if $add_path {
    windows_env { "PATH=C:\\Program Files (x86)\\NUnit ${version}\\bin":
      require => Windows::Downloadable_package["NUnit ${version}"],
    }
  }
}
