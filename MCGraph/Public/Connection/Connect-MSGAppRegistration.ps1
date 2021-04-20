function Connect-MSGAppRegistration {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Secret")][ValidateNotNullOrEmpty()][string]$TenantId,
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "Secret")][ValidateNotNullOrEmpty()][string]$ApplicationId,
        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "Secret")][ValidateNotNullOrEmpty()][string]$Secret,
        [Parameter(Mandatory = $false, Position = 3, ParameterSetName = "Secret")][string]$Proxy,
        [Parameter(Mandatory = $false, Position = 4, ParameterSetName = "Secret")][pscredential]$ProxyCredential,
        

        # Client assertion certificate of the client requesting the token.
        [parameter(Mandatory = $true, ParameterSetName = 'Certificate')]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate
    )
    
    begin {
        $_Session = [Session]::new()
    }
    
    process {
        if ($Proxy) {
            $_Session.ProxySettings = [ProxySettings]::New()
            $_Session.ProxySettings.Address = $Proxy
            $_Session.ProxySettings.Credential = $ProxyCredential
        }
        $_Session.AuthenticationType = [AuthenticationType]::ApplicationIdWithSecret
        $_Session.Credentials = [CredentialDetails]::new($TenantId, $ApplicationId, $Secret)   
        $script:Session = $_Session
        $_Session.RefreshToken()
        
    }   
    
    end {
        $session
    }
}