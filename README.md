# MCGraph module
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

### Example: Get all users with a displayname that starts with michael

```PowerShell
Get-MSGUser michael 

Get-MSGUser ${DisplayName= "michael"}

Get-MSGUser -startswith ${DisplayName= "michael"}
```

Output is limited to 100 records by default. You're allowed to request up to 999 record in one api call. To get all available records you can simply add the"-AllRecords" switch. This will automatically call itterate the api call and collect alle avaible records as a response.  

### Example: 

```PowerShell
Get-MSGUser -top 1 #to max 999

Get-MSGUser -AllRecords 
```



## Special thanks to 
@RamblingCookieMonster: Build/Test/Deploy framework

## Scope & Contributing
Contributions are gratefully received, so please feel free to submit a pull request with additional features.
