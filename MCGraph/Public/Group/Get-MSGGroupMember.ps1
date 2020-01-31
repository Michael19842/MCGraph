function Get-MSGGroupMember {
    [CmdletBinding(DefaultParameterSetName="Identity")]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position = 0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,
        
        [Parameter(Mandatory = $false)] [hashtable] $IsExactly,
        [Parameter(Mandatory = $false)] [hashtable] $StartsWith,
        [Parameter(Mandatory = $false)] [String] $CustomFilter,

        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $DefaultRecordLimit,
        
        [switch] $Transitive
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
        
        if ($Transitive) {
            $uri = Get-MSGEndPoint -EndPoint "msGraphV1GroupTransitiveMembers" -EndPointParameters @{Identity = [System.Web.HttpUtility]::UrlEncode($UsedIdentity)}
        } else {
            $uri = Get-MSGEndPoint -EndPoint "msGraphV1GroupMembers" -EndPointParameters @{Identity = [System.Web.HttpUtility]::UrlEncode($UsedIdentity)}
        }

        $ReturnValue = get-msgObject -uri (Format-MSGUri -uri $uri -Select $Select -top $Top -IsExactly $IsExactly -StartsWith $StartsWith -CustomFilter $CustomFilter) -limitedOutput:([bool]$top)
        
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"MSGraph.Users")}
        }
        Return $ReturnValue 
    }
    
    end {
        
    }
}