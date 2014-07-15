class windows::jdk(
  $version = '7u60',
) {
  include windows::params

  windows_java::jdk { "JDK ${version}":
    version => $version,
    temp_target => $windows::params::downloadsdir,
  }
}

