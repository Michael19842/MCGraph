function Get-MSGRoom {
    [CmdletBinding(DefaultParameterSetName="Identity")]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position = 0)][String] $emailAddressString,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $emailAddress,
        
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
                $usedEmailAddress = $emailAddressString
            }
            "Object" {
                $usedEmailAddress = $emailAddress
            }
        }
        
        $uri = Get-MSGEndPoint -EndPoint "msGraphBetaPlaceRoomlistRooms" -EndPointParameters @{Emailaddress = [System.Web.HttpUtility]::UrlEncode($usedEmailAddress)}


        $ReturnValue = Get-msgObject -uri (Format-MSGUri -uri $uri -Select $Select -top $Top -IsExactly $IsExactly -StartsWith $StartsWith -CustomFilter $CustomFilter) -limitedOutput:([bool]$top)
        
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"MSGraph.Rooms")}
        }
        Return $ReturnValue 
    }
    
    end {
        
    }
}