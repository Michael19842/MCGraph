function Get-MSGManagedDevice {
    [CmdletBinding(DefaultParameterSetName = "GeneratedFilter")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter", Position = 0)] [ValidateScript({Confirm-MSGStartWithParamType $_})] $StartsWith,
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter")] [hashtable] $IsExactly,

        [Parameter(Mandatory = $true, ParameterSetName = "CustomFilter")][ValidateNotNullOrEmpty] [String] $CustomFilter,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $DefaultRecordLimit,
        
        <#
            !Not yet implemented by Microsoft (30-10-2019)
        #>
        #[Parameter(Mandatory = $false)] [int] $Skip 
        
        [switch] $AllRecords

    )
    
    begin {
        $_StartsWith = Convert-MSGStartsWith $StartsWith -DefaultProperty "deviceName"
        
        $Uri = Format-MSGUri -uri (Get-MSGEndPoint "msGraphV1ManagedDevices") -IsExactly $IsExactly -StartsWith $_StartsWith -Top $Top -Select $Select -CustomFilter $CustomFilter -AllRecords:$AllRecords
    }
    
    process {
        Try {
            $ReturnValue = Get-MSGObject -uri $Uri -limitedOutput:([bool]$top -and !$AllRecords )
        }
        Catch [System.UnauthorizedAccessException] {
            Throw [System.UnauthorizedAccessException]::new("Permision DeviceManagementManagedDevices.Read.All or DeviceManagementManagedDevices.ReadWrite.All missing ")
        }
    }
    
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"MSGraph.Device")}
        }
        Return $ReturnValue 
    }
}