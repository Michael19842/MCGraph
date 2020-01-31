
function Get-MSGToken {
    <#
    .PARAMETER Scope
    The value passed for the scope parameter in this request should be the resource identifier (Application ID URI) of the resource you want, 
    affixed with the .default suffix. For Microsoft Graph, the value is https://graph.microsoft.com/.default. This value informs the Microsoft 
    identity platform endpoint that of all the application permissions you have configured for your app, it should issue a token for the ones 
    associated with the resource you want to use.

    #>
    #[OutputType([Token])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0,ParameterSetName = "ApplicationSecret")][ValidateNotNullOrEmpty()][string]$TenantId,
        [Parameter(Mandatory=$true, Position=1,ParameterSetName = "ApplicationSecret")][ValidateNotNullOrEmpty()][string]$ApplicationId,
        [Parameter(Mandatory=$true, Position=2,ParameterSetName = "ApplicationSecret")][ValidateNotNullOrEmpty()][string]$Secret,
        [Parameter(Mandatory=$false, Position=3,ParameterSetName = "ApplicationSecret")][ValidateNotNullOrEmpty()][string]$Scope = "msGraphDefaultScope"
    )
    
    begin {
        $uri = Get-MSGEndPoint -EndPoint "msOAuthv2" -EndPointParameters @{TenantId = $TenantId}
    }
    
    process {
        switch ($PsCmdlet.ParameterSetName) {
            "ApplicationSecret" {
                $RequestBody = @{
                    client_id     = $ApplicationId
                    scope         = Get-MSGEndPoint -EndPoint $Scope
                    client_secret = $Secret
                    grant_type    = "client_credentials"
                }

            }
        }

        if($RequestBody -and $uri) {
            try{
                $tokenRequest = Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/x-www-form-urlencoded" -Body $RequestBody -UseBasicParsing
                $tokenContent = $tokenRequest.Content | ConvertFrom-Json

                $ReturnToken = [Token]::new($tokenContent.token_type,$tokenContent.access_token,$tokenContent.expires_in)
            }
            catch {
                $ReturnToken = [Token]::new($false,"TokenRequest invalid")
            }
            Return $ReturnToken
        }
        else {
            $ReturnToken = [Token]::new($false,"TokenRequest incomplete")
        }
    }
    
    end {
        
    }
}
