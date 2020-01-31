

function Get-MSGObjectReference {
    [CmdletBinding(DefaultParameterSetName="Identity")]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position = 0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,

        [Parameter(Mandatory = $false)][ObjectType] $ObjectType = [ObjectType]::directoryObject
                
    )
    
    process {
        switch ($PsCmdlet.ParameterSetName) {
            "Identity" {
                $UsedIdentity = $Identity
            }
            "Object" {
                $UsedIdentity = $id
            }
        }

        switch ($ObjectType) {
            ([ObjectType]::directoryObject) {  
                Return Get-MSGEndPoint -EndPoint "msGraphV1DirectoryObject" -EndPointParameters @{Identity = $UsedIdentity }
            }
            ([ObjectType]::group) {  
                Return Get-MSGEndPoint -EndPoint "msGraphV1Group" -EndPointParameters @{Identity = $UsedIdentity }
            }
            ([ObjectType]::user) { 
                Return Get-MSGEndPoint -EndPoint "msGraphV1User" -EndPointParameters @{Identity = $UsedIdentity }
             }
            Default {}
        }
    }
}
