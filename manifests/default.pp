# TODO: split into some classes, configure with hiera

$downloads_dir = 'C:\Downloads'
Pget {
  target => $downloads_dir,
}

windows_java::jdk { "JDK 7":
  version => '7u60',
  temp_target => $downloads_dir,
}

package { "Microsoft Build Tools 2013":
  ensure          => installed,
  source          => 'C:\Downloads\BuildTools_Full.exe',
  install_options => ['/S', '/NoWeb'],
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

pget { 'Download ImDisk':
  source => "http://www.ltr-data.se/files/imdiskinst.exe",
} ->
# Can't use package to install, as it needs the environment variable
exec { "install-imdisk":
  command     => "${downloads_dir}\\imdiskinst.exe -y",
  environment => 'IMDISK_SILENT_SETUP=1',
  creates     => 'C:\Windows\system32\imdisk.exe',
} ->
pget { 'Download Windows SDK':
  source => "http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDKX_EN_DVD.iso",
} ->
exec { "mount-windows-sdk":
  command => "imdisk -a -f ${downloads_dir}\\GRMSDKX_EN_DVD.iso -m J:",
  creates => 'J:\setup.exe',
  path    => 'C:\Windows\system32',
} ->
package { "Microsoft Windows SDK for Windows 7 (7.1)":
  ensure          => installed,
  source          => 'J:\setup.exe',
  install_options => ['-q', '-params:ADDLOCAL=ALL'],
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

