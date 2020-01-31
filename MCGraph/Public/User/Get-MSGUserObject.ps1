function Get-MSGUserObject {
    [CmdletBinding(DefaultParameterSetName ="Identity")]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position =0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $userPrincipalName, 
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,
        
        [Parameter(Mandatory = $false)] [array] $Select,  
        [Parameter(Mandatory = $false)] [String] $Expand     
    )

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

        $uri = Get-MSGEndPoint -EndPoint "msGraphV1User" -EndPointParameters @{Identity = [System.Web.HttpUtility]::UrlEncode($UsedIdentity)}
        
        Return Get-MSGObject -uri (Format-MSGUri -uri $uri -Select $Select -Expand $Expand)
    }
}