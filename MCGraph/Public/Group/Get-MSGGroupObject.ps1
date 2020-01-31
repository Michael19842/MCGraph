function Get-MSGGroupObject {
    [CmdletBinding(DefaultParameterSetName="Identity")]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position = 0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,
        
        [Parameter(Mandatory = $false,Position =1)] [array] $Select,
        [switch] $ExpandMembers
    )
    
    begin {
       
    }
    
    process {
        switch ($PsCmdlet.ParameterSetName) {
            "Identity" {
                $UsedIdentity = $Identity
            }
            "Object" {
                $UsedIdentity = $id
            }
        }

        $uri = Get-MSGEndPoint -EndPoint "msGraphV1Group" -EndPointParameters @{Identity = [System.Web.HttpUtility]::UrlEncode($UsedIdentity)}
        
        $Expand = if($ExpandMembers){"members"} 
        Return get-msgObject -uri (Format-MSGUri -uri $uri -Select $Select -Expand $Expand)
    }
}