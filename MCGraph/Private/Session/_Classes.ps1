#Enumeration of authentication types used to create the session object
enum AuthenticationType {
    ApplicationIdWithSecret 
    ApplicationIdWithCertificate
}

#Enumeration of objecttype used to generate the objects reference uri
enum ObjectType {
    group 
    user
    directoryObject
}

class Token {
    [datetime] $ExpireDateTime
    [string] $Type
    [string] $Value 
    [bool]  $Valid
    [string] $Reason

    Token() {
        $this.Valid = $false
        $this.Reason = "No token information present"
    }
    
    Token([bool]$Valid = $false, $Reason) {
        $this.Valid = $Valid
        $this.Reason = $Reason
    }

    Token ([string]$Type, [string]$Value, [int]$ExpiresIn) {
        $this.Type = $Type
        $this.Value = $Value
        $this.ExpireDateTime = (Get-date).AddSeconds($ExpiresIn)  
        $this.Valid = $true
    }
}

class CredentialDetails {
    [string] $TenantId
    [string] $ApplicationId
    [string] $Secret
    CredentialDetails() {

    }
    CredentialDetails([string]$TenantId, [string]$ApplicationId, [string]$Secret) {
        $this.TenantId = $TenantId
        $this.ApplicationId = $ApplicationId
        $this.Secret = $Secret
    }
}

Class ProxySettings {
    [string] $Address
    [pscredential] $Credential
}

class Request {
}



class Session {
    [AuthenticationType] $AuthenticationType
    [CredentialDetails] $Credentials
    [ProxySettings] $ProxySettings
    [Token] $Token 
    Session() {
    }
    [Token] GetToken() {
        return $this.Token
        if ($this.Credentials) {
            if (!$this.Token -or ($this.Token.ExpireDateTime).AddMinutes(-1) -gt (get-date)) {
                $this.RefreshToken()
            }   
        }
        if ($this.Token.Valid) {
            return $this.Token
        }
        else {
            throw ([System.InvalidOperationException]::new($this.Token))
        }
    }
    RefreshToken() {
        if ($this.Credentials) {
            switch ($this.AuthenticationType) {
                ([AuthenticationType]::ApplicationIdWithSecret) { 
                    $this.Token = Get-MSGToken `
                        -TenantId $this.Credentials.TenantId `
                        -ApplicationId $this.Credentials.ApplicationId `
                        -Secret $this.Credentials.Secret
                }
                ([AuthenticationType]::ApplicationIdWithCertificate) {  
                    throw ([System.NotImplementedException]::new("Not supported yet"))
                }
                Default {
                    $this.AuthenticationType
                    throw ([System.NotImplementedException]::new("Unknown authentication type"))
                }
            }
        }
        else {
            throw ([System.InvalidOperationException]::new("Credential information missing"))
        }
    }
}

