function Get-MSGUserOwnedObject {
    <#
        .SYNOPSIS
        Get a users group memberships

        .DESCRIPTION
        Returns the manager op a user

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

        http://www.fabrikam.com/extension.html

        .LINK

        Set-Item
    #>
        [CmdletBinding(DefaultParameterSetName ="Identity")]
        param (
            # Parameter help description
            [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position=0)][String] $Identity,
            [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $userPrincipalName, 
            [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,
            
            [Parameter(Mandatory = $false)] [hashtable] $IsExactly,
            [Parameter(Mandatory = $false)] [hashtable] $StartsWith,
            [Parameter(Mandatory = $false)] [String] $CustomFilter,
    
            [Parameter(Mandatory = $false)] [array] $Select,
            [Parameter(Mandatory = $false)] [int] $Top = $DefaultRecordLimit
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
    
            $uri = Get-MSGEndPoint -EndPoint "msGraphV1UserOwnedObjects" -EndPointParameters @{Identity = [System.Web.HttpUtility]::UrlEncode($UsedIdentity)}
            
            $ReturnValue = get-msgObject -uri (Format-MSGUri -uri $uri -Select $Select -top $Top -IsExactly $IsExactly -StartsWith $StartsWith -CustomFilter $CustomFilter) -limitedOutput ([bool]$top)

            if(!$Select){
                $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"MSGraph.Groups")}
            }
            Return $ReturnValue
        }
        
        end {
            
        }
    }