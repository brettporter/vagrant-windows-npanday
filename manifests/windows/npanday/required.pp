class windows::npanday::required {
  include windows::nunit

  # Just install the .NET Framework SDK from latest
  windows::downloadable_package { "Windows Software Development Kit for Windows 8.1":
    url             => "http://download.microsoft.com/download/B/0/C/B0C80BA3-8AD6-4958-810B-6882485230B5/standalonesdk/sdksetup.exe",
    install_options => ['/q', '/features', 'OptionId.NetFxSoftwareDevelopmentKit'],
  }
  windows::downloadable_package { "Microsoft Build Tools 2013":
    url             => "http://download.microsoft.com/download/9/B/B/9BB1309E-1A8F-4A47-A6C5-ECF76672A3B3/BuildTools_Full.exe",
    install_options => ['/S', '/NoWeb'],
  }

}

