define windows::chocolatey_webpi_package {
  include windows::chocolatey_webpi

  # Weird quoting due to
  # https://github.com/chocolatey/puppet-chocolatey/issues/15
  if ($windows::chocolatey_webpi::offlineCache != undef) {
    package { $name:
      ensure          => installed,
      provider        => chocolatey,
      source          => webpi,
      install_options => ["-installArgs",
        sprintf('"/Xml:%s',"${windows::chocolatey_webpi::offlineCache}\\feeds\\latest\\webproductlist.xml"),
        sprintf('/SQLPassword:%s"', $windows::chocolatey_webpi::sqlPassword)],
      require         => Windows::Downloadable_Package["Microsoft Web Platform Installer 4.6"],
    }
  }
  else {
    package { $name:
      ensure          => installed,
      provider        => chocolatey,
      source          => webpi,
      install_options => ["-installArgs", "/SQLPassword:${windows::chocolatey_webpi::sqlPassword}"],
      require         => Windows::Downloadable_Package["Microsoft Web Platform Installer 4.6"],
    }
  }
}
