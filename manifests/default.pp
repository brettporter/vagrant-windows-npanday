# TODO: split into some classes

$jdk_major = '7'
$jdk_update = '60'

package { "Java SE Development Kit ${jdk_major} Update ${jdk_update} (64-bit)":
  ensure          => installed,
  source          => "c:\\Downloads\\jdk-${jdk_major}u${jdk_update}-windows-x64.exe",
  install_options => ['/s', 'WEB_JAVA=0'],
} ->
windows_env { "JAVA_HOME=C:\\Program Files\\Java\\jdk1.${jdk_major}.0_${jdk_update}":
  mergemode => 'clobber'
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

# TODO: move to class, then configure with hiera
maven::settings { "user-maven-settings":
  home    => 'C:\Users\vagrant',
  user    => 'vagrant',
  mirrors => hiera('maven_mirrors', []),
}
