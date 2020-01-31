# MCGrapht module
This module is build as a means to interact with Microsoft Graph via an app registration using Powershell.

## Usage

### Installation
#### Using Powershell Gallery

```PowerShell
Install-Module -Name MCGraph
```

## Examples

### Example: Connecting to MS Graph

Connect to MSGraph using an App-Registration

```PowerShell
$params = @{
    TenantId = "{{Your tenentID}}"
    ApplicationId = "{{Your application id}}"
    Secret = "{{Your secret}}"
}

Connect-MSGAppRegistration @params
```

### Example: 

```PowerShell
```


## Special thanks to 
@RamblingCookieMonster: Build/Test/Deploy framework

## Scope & Contributing
Contributions are gratefully received, so please feel free to submit a pull request with additional features.
