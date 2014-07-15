class windows::windows_sdk(
  $version = "7.1",
  $extract_dir = 'c:\tmp\windows-sdk',
) {
  include windows::params

  validate_re($version, '7\.[0|1]')

  windows::downloadable_package { '7-Zip 9.20 (x64 edition)':
    source => "http://downloads.sourceforge.net/sevenzip/7z920-x64.msi",
  }

  case $version {
    '7.0': {
      # Windows 7.0 SDK (.NET 3.5 SP1)
      $packagename = "Microsoft Windows SDK for Windows 7"
      $downloadurl = 'http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDKX_EN_DVD.iso'
    }
    '7.1': {
      # Windows 7.1 SDK (.NET 4.0)
      $packagename = "Microsoft Windows SDK for Windows 7 (7.1)"
      $downloadurl = 'http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDKX_EN_DVD.iso'
    }
  }

  pget { 'Download Windows SDK':
    source => $downloadurl,
    target => $windows::params::downloadsdir,
  } ->
  exec { "extract-windows-sdk":
    command => "\"C:\\Program Files\\7-Zip\\7z.exe\" x ${windows::params::downloadsdir}\\GRMSDKX_EN_DVD.iso -o${extract_dir}",
    creates => $extract_dir,
  } ->
  package { $packagename:
    ensure          => installed,
    source          => "${extract_dir}\\setup.exe",
    install_options => ['-q', '-params:ADDLOCAL=ALL'],
  }
}
