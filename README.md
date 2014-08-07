Vagrant setup for .NET command line tools
-----------------------------------------

This vagrant box provisions the necessary tools to build .NET applications
from the command line, and to build and run Apache NPanday including its
integration tests.

Puppet is used to configure the necessary software. It in turn downloads and
installs several MSI packages, and uses Chocolatey and the Web Platform
Installer where appropriate.

* Caching Web Platform Installer Packages

To avoid redownloading each time it is provisioned, you can configure a cache
directory in Hiera:

```
windows::chocolatey_webpi::offlineCache: 'C:\Downloads\webpicache'
```

To populate this, you need to have mounted the directory on an existing
Windows VM and run the Web Platform Installer in offline mode:

```
"c:\Program Files\Microsoft\Web Platform Installer\WebpiCmd.exe" /Offline /Products:VS2010SI,MVC2,MVC3,WDeploy_2_1,WindowsAzureSDK_1_7 /Path:C:\Downloads\WebPICache
```

