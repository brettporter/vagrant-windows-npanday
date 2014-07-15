class windows::npanday::tests {
  windows::downloadable_package { "Windows Azure Authoring Tools - November 2011":
    url => "http://download.microsoft.com/download/D/F/4/DF442AB0-FAAE-44FF-A04E-F41E72FE6B6F/WindowsAzureSDK-x64.msi",
  }
  windows::chocolatey_webpi_package { "WindowsAzureSDK_1_7": }

  windows::downloadable_package { "Microsoft Silverlight 3 SDK":
    url => "http://download.microsoft.com/download/F/5/1/F516C774-3BD1-40E0-BB51-2CDC9FD8D63A/silverlight_sdk.exe",
  }

  windows::chocolatey_webpi_package { "MVC2": }
  windows::chocolatey_webpi_package { "WDeploy_2_1": }
}

