# TODO: split into some classes, configure with hiera

$downloads_dir = 'C:\Downloads'
Pget {
  target => $downloads_dir,
}

windows_java::jdk { "JDK 7":
  version => '7u60',
  temp_target => $downloads_dir,
}

$git_version = '1.9.4-preview20140611'
pget { 'Download Git':
  source => "https://github.com/msysgit/msysgit/releases/download/Git-${git_version}/Git-${git_version}.exe",
}
package { "Git version ${git_version}":
  ensure          => installed,
  source          => "${downloads_dir}/Git-${git_version}.exe",
  install_options => ['/VERYSILENT'],
}

create_resources(host, hiera_hash('hosts'))

$apache_mirror = "http://archive.apache.org/dist"
$mvn_version = "3.0.5"
$maven_basedir = 'C:\Program Files\Apache Maven'
$maven_installdir = "${maven_basedir}\\apache-maven-${mvn_version}"
file { $maven_basedir:
  ensure => directory,
}
pget { 'Download Maven':
  source => "${apache_mirror}/maven/binaries/apache-maven-${mvn_version}-bin.zip",
} ->
unzip { "Unzip Maven":
  source  => "${downloads_dir}/apache-maven-${mvn_version}-bin.zip",
  creates => $maven_installdir,
  require => File[$maven_basedir],
} ->
windows_env { "M2_HOME=${maven_installdir}":
  mergemode => 'clobber'
} ->
windows_env { "PATH=${maven_installdir}\\bin":
}

maven::settings { "user-maven-settings":
  home    => 'C:\Users\vagrant',
  user    => 'vagrant',
  mirrors => hiera('maven_mirrors', []),
}

# Install Chocolatey
exec { "install-chocolatey":
  command  => "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))",
  provider => powershell,
  creates  => 'C:\ProgramData\chocolatey',
} ->
windows_env { 'PATH=C:\ProgramData\chocolatey\bin':
}

package { "wixtoolset":
  ensure   => installed,
  provider => chocolatey,
} ->
windows_env { 'PATH=C:\Program Files (x86)\WiX Toolset v3.8\bin':
}

pget { 'Download 7-Zip':
  source => "http://downloads.sourceforge.net/sevenzip/7z920-x64.msi",
} ->
package { '7-Zip 9.20 (x64 edition)':
  ensure => installed,
  source => "${downloads_dir}\\7z920-x64.msi",
}

#pget { 'Download Windows SDK':
  # Windows 7.0 SDK (.NET 3.5 SP1)
  #source => "http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDKX_EN_DVD.iso",
  # Windows 7.1 SDK (.NET 4.0)
  #source => "http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDKX_EN_DVD.iso",
#} ->
#exec { "extract-windows-sdk":
  #command => "\"C:\\Program Files\\7-Zip\\7z.exe\" x ${downloads_dir}\\GRMSDKX_EN_DVD.iso -oC:\\tmp\\windows-sdk",
  #creates => 'C:\tmp\windows-sdk',
#} ->
#package { "Microsoft Windows SDK for Windows 7 (7.1)":
  #ensure          => installed,
  #source          => 'C:\tmp\windows-sdk\setup.exe',
  #install_options => ['-q', '-params:ADDLOCAL=ALL'],
#}

package { "Microsoft Build Tools 2013":
  ensure          => installed,
  source          => 'C:\Downloads\BuildTools_Full.exe',
  install_options => ['/S', '/NoWeb'],
}

# Just install the .NET Framework SDK from latest
pget { 'Download Windows 8.1 SDK installer':
  source => "http://download.microsoft.com/download/B/0/C/B0C80BA3-8AD6-4958-810B-6882485230B5/standalonesdk/sdksetup.exe",
} ->
package { "Windows Software Development Kit for Windows 8.1":
  ensure          => installed,
  source          => "${downloads_dir}/sdksetup.exe",
  install_options => ['/q', '/features', 'OptionId.NetFxSoftwareDevelopmentKit'],
}

$nunit_version = '2.6.3'
pget { 'Download NUnit':
  source => "http://launchpad.net/nunitv2/trunk/${nunit_version}/+download/NUnit-${nunit_version}.msi",
} ->
package { "NUnit ${nunit_version}":
  ensure => installed,
  source => "${downloads_dir}\\NUnit-${nunit_version}.msi",
} ->
windows_env { "PATH=C:\\Program Files (x86)\\NUnit ${nunit_version}\\bin":
}

pget { 'Download Azure 1.6 SDK':
  source => "http://download.microsoft.com/download/D/F/4/DF442AB0-FAAE-44FF-A04E-F41E72FE6B6F/WindowsAzureSDK-x64.msi",
} ->
package { "Windows Azure Authoring Tools - November 2011":
  ensure => installed,
  source => "${downloads_dir}\\WindowsAzureSDK-x64.msi",
}

pget { 'Download Silverlight 3 SDK':
  source => "http://download.microsoft.com/download/F/5/1/F516C774-3BD1-40E0-BB51-2CDC9FD8D63A/silverlight_sdk.exe",
} ->
package { "Microsoft Silverlight 3 SDK":
  ensure => installed,
  source => "${downloads_dir}\\silverlight_sdk.exe",
}
