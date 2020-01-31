  <#
    .SYNOPSIS
    Get the manager of a user 

    .DESCRIPTION
    If a user's OneDrive is not provisioned but the user has a license to use OneDrive, 
    this request will automatically provision the user's drive, when using delegated authentication.

    .PARAMETER EndPoint
    String containing the name of the endpoint 

    .PARAMETER EndPointParameters
    Optional hashtable parameter containing the value of the parameter in EndPoint 

    .INPUTS

    User Object containing a UserPrincipleName or a Users ID

    .OUTPUTS

    User, if one is present. If not it will throw a 404 error 

    .EXAMPLE

    PS> Get-MSGUserManager "some.user@company.com" -verbose | Get-MSGUserManager -verbose

    .EXAMPLE

    Chaining manager lookup can be achieved like so (eg. users>manager>manager )
    PS> Get-MSGUserManager "some.user@company.com" -verbose | Get-MSGUserManager -verbose
    File.doc

    .EXAMPLE

    PS> extension "File" "doc"
    File.doc

    .LINK

    https://docs.microsoft.com/en-us/graph/api/drive-get?view=graph-rest-1.0&tabs=http#get-current-users-onedrive

    .LINK

    Set-Item
    #>

    function Initialize-MSGUserOneDrive {
        [CmdletBinding(DefaultParameterSetName ="Identity")]
        param (
            # Parameter help description
            [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position=0)][String] $Identity,
            [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $userPrincipalName, 
            [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,
            
            [Parameter(Mandatory = $false)] [array] $Select
        )
        
        begin {
           
        }
        
        process {
            switch ($PsCmdlet.ParameterSetName) {
                "Identity" {
                    $UsedIdentity = $Identity
                }
                "Object" {
                    # if there is a upn and it does not contain a "$" character (which fails) the use the upn as it is most descriptive and humanly readable
                    if($userPrincipalName -and $userPrincipalName -notmatch "[\$]") {
                        $UsedIdentity =$userPrincipalName
                        Write-Verbose "Getting MS Graph User using upn $userPrincipalName"
                    }
                    else {
                        $UsedIdentity = $id
                    }
                }
            }
    
            $uri = Get-MSGEndPoint -EndPoint "msGraphV1UserDrive" -EndPointParameters @{Identity = [System.Web.HttpUtility]::UrlEncode($UsedIdentity)}
            
            Return get-msgObject -uri (Format-MSGUri -uri $uri -Select $Select)
        }
        
        end {
            
        }
    }