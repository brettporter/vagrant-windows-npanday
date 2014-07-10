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
