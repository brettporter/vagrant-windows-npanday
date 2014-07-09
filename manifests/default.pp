# TODO: split into some classes, configure with hiera

$downloads_dir = 'C:\Downloads'

# TODO: fold in cookie string, support using a mounted download location
windows_java::jdk { "JDK 7":
  version => '7u60',
  temp_target => $downloads_dir,
  cookie_string => 'oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com',
}

package { "Microsoft Build Tools 2013":
  ensure          => installed,
  source          => 'C:\Downloads\BuildTools_Full.exe',
  install_options => ['/S', '/NoWeb'],
}

$git_version = '1.9.4-preview20140611'
pget { 'Download Git':
  source => "https://github.com/msysgit/msysgit/releases/download/Git-${git_version}/Git-${git_version}.exe",
  target => $downloads_dir,
}
package { "Git version ${git_version}":
  ensure          => installed,
  source          => "${downloads_dir}/Git-${git_version}.exe",
  install_options => ['/VERYSILENT'],
}

create_resources(host, hiera_hash('hosts'))

$mvn_version = "3.0.5"
$maven_basedir = 'C:\Program Files\Apache Maven'
$maven_installdir = "${maven_basedir}\\apache-maven-${mvn_version}"
file { $maven_basedir:
  ensure => directory,
} ->
exec { "unpack-maven":
  command  => "
\$shellApplication = New-Object -com shell.application
\$zipFile =
\$shellApplication.NameSpace('C:\\Downloads\\apache-maven-${mvn_version}-bin.zip')
\$destFolder = \$shellApplication.NameSpace('${maven_basedir}')
\$destFolder.CopyHere(\$zipFile.Items())",
  provider => powershell,
  creates  => $maven_installdir,
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
