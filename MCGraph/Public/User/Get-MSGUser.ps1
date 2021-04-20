function Get-MSGUser {
    [CmdletBinding(DefaultParameterSetName = "GeneratedFilter")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter", Position = 0)] [ValidateScript( { Confirm-MSGStartWithParamType $_ })] $StartsWith,
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter")] [hashtable] $IsExactly,

        [Parameter(Mandatory = $true, ParameterSetName = "CustomFilter")][ValidateNotNullOrEmpty()] [String] $CustomFilter,
        [Parameter(Mandatory = $false)] [array] $Select,
        [Parameter(Mandatory = $false)] [int] $Top = $DefaultRecordLimit,

        [switch] $AllRecords
        
        <#
            !Not yet implemented by Microsoft (30-10-2019)
        #>
        #[Parameter(Mandatory = $false)] [int] $Skip 

    )
    
    begin {
        $_StartsWith = Convert-MSGStartsWith $StartsWith
        
        $Uri = Format-MSGUri -uri (Get-MSGEndPoint "msGraphV1Users") -IsExactly $IsExactly -StartsWith $_StartsWith -Top $Top -Select $Select -CustomFilter $CustomFilter -AllRecords:$AllRecords 
    }
    
    process {
        $ReturnValue = Get-MSGObject -uri $Uri -limitedOutput:([bool]$top -and !$AllRecords )
    }
    
    end {
        if (!$Select) {
            $ReturnValue | ForEach-Object { $_.PSObject.TypeNames.Insert(0, "MSGraph.Users") }
        }
        Return $ReturnValue 
    }
}