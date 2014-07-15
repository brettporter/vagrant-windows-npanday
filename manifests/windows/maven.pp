# TODO: move into puppet-maven?
class windows::maven(
  $apache_mirror = "http://archive.apache.org/dist",
  $version = "3.0.5",
  $install_basedir = 'C:\Program Files\Apache Maven',
  $user,
  $user_home = undef,
  $maven_mirrors = [],
) {
  include windows::params
  include windows::jdk

  $installdir = "${install_basedir}\\apache-maven-${version}"
  file { $install_basedir:
    ensure => directory,
  }

  pget { 'Download Maven':
    source => "${apache_mirror}/maven/binaries/apache-maven-${version}-bin.zip",
    target => $windows::params::downloadsdir,
  } ->
  unzip { "Unzip Maven":
    source  => "${windows::params::downloadsdir}/apache-maven-${version}-bin.zip",
    creates => $installdir,
    require => File[$install_basedir],
  } ->
  windows_env { "M2_HOME=${installdir}":
    mergemode => 'clobber'
  } ->
  windows_env { "PATH=${installdir}\\bin":
  }

  maven::settings { "user-maven-settings":
    home    => $user_home ? { undef => "C:\\Users\\${user}", default => $user_home, },
    user    => $user,
    mirrors => $maven_mirrors,
  }

}
