# Might be possible via puppet-chocolatey in future - see
# https://github.com/chocolatey/puppet-chocolatey/pull/24
class windows::chocolatey {
  # Install Chocolatey
  exec { "install-chocolatey":
    command  => "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))",
    provider => powershell,
    creates  => 'C:\ProgramData\chocolatey',
  } ->
  windows_env { 'PATH=C:\ProgramData\chocolatey\bin':
  }
}
