class windows::npanday::optional {
  # VS 2010 Shell Integration for Addin build files
  windows::chocolatey_webpi_package { "VS2010SI": }

  # WiX for distro and integration tests
  package { "wixtoolset":
    ensure   => installed,
    provider => chocolatey,
  } ->
  windows_env { 'PATH=C:\Program Files (x86)\WiX Toolset v3.8\bin':
  }

}
