class windows::chocolatey_webpi(
  $offlineCache = undef,
) {

  include windows::chocolatey

  windows::downloadable_package { "Microsoft Web Platform Installer 4.6":
    url => "http://download.microsoft.com/download/7/0/4/704CEB4C-9F42-4962-A2B0-5C84B0682C7A/WebPlatformInstaller_amd64_en-US.msi",
  }
}
