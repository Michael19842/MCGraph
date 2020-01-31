function Connect-MSGAppRegistration {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory=$true, Position=0,ParameterSetName = "Secret")][ValidateNotNullOrEmpty()][string]$TenantId,
        [Parameter(Mandatory=$true, Position=1,ParameterSetName = "Secret")][ValidateNotNullOrEmpty()][string]$ApplicationId,
        [Parameter(Mandatory=$true, Position=2,ParameterSetName = "Secret")][ValidateNotNullOrEmpty()][string]$Secret,

        # Client assertion certificate of the client requesting the token.
        [parameter(Mandatory=$true, ParameterSetName='Certificate')]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate
    )
    
    begin {
        $_Session = [Session]::new()
    }
    
    process {
        $_Session.AuthenticationType = [AuthenticationType]::ApplicationIdWithSecret
        $_Session.Credentials = [CredentialDetails]::new($TenantId,$ApplicationId,$Secret)   
        $_Session.RefreshToken()
        $script:Session = $_Session
    }   
    
    end {
        $session
    }
}