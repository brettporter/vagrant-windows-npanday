define windows::chocolatey_webpi_package {
  include windows::chocolatey_webpi

  if ($windows::chocolatey_webpi::offlineCache != undef) {
    package { $name:
      ensure          => installed,
      provider        => chocolatey,
      source          => webpi,
      install_options => ["-installerArguments","/Xml:${windows::chocolatey_webpi::offlineCache}\\feeds\\latest\\webproductlist.xml"],
      require         => Windows::Downloadable_Package["Microsoft Web Platform Installer 4.6"],
    }
  }
  else {
    package { $name:
      ensure          => installed,
      provider        => chocolatey,
      source          => webpi,
      require         => Windows::Downloadable_Package["Microsoft Web Platform Installer 4.6"],
    }
  }
}
