# TODO: split into some classes, configure with hiera

# TODO: fold in cookie string, support downloads with overwriting
windows_java::jdk { "JDK 7":
  version => '7u60',
  cookie_string => 'oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com',
}

package { "Microsoft Build Tools 2013":
  ensure          => installed,
  source          => 'C:\Downloads\BuildTools_Full.exe',
  install_options => ['/S', '/NoWeb'],
}

package { "Git version 1.9.4-preview20140611":
  ensure          => installed,
  source          => 'C:\Downloads\Git-1.9.4-preview20140611.exe',
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
