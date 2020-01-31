function Get-MSGGroup {
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
        $_StartsWith = Convert-MSGStartsWith $StartsWith

        $params = @{
            uri = (Get-MSGEndPoint "msGraphV1Groups") 
            IsExactly = $IsExactly 
            StartsWith = $_StartsWith 
            Top = $Top
            Select = $Select
            CustomFilter = $CustomFilter
        }

        $Uri = Format-MSGUri @params -AllRecords:$AllRecords
    }
    
    process {
        $ReturnValue = Get-MSGObject -uri $Uri  -limitedOutput:([bool]$top -and !$AllRecords )
    }
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"MSGraph.Groups")}
        }
        Return $ReturnValue
    }
    
}