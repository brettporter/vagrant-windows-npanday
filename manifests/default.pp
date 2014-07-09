$jdk_major = '7'
$jdk_update = '60'

package { "Java SE Development Kit ${jdk_major} Update ${jdk_update} (64-bit)":
  ensure          => installed,
  source          => "c:\\Downloads\\jdk-${jdk_major}u${jdk_update}-windows-x64.exe",
  install_options => ['/s', 'WEB_JAVA=0'],
}
windows_env { "JAVA_HOME=C:\\Program Files\\Java\\jdk1.${jdk_major}.0_${jdk_update}":
  mergemode => 'clobber'
}

package { "Microsoft Build Tools 2013":
  ensure          => installed,
  source          => 'C:\Downloads\BuildTools_Full.exe',
  install_options => ['/S', '/NoWeb'],
}

create_resources(host, hiera_hash('hosts'))
