function Get-MSGSchedule {
    [CmdletBinding(DefaultParameterSetName = "GeneratedFilter")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter", Position = 0)] [ValidateScript({Confirm-MSGStartWithParamType $_})] $StartsWith,
        [Parameter(Mandatory = $false, ParameterSetName = "GeneratedFilter")] [hashtable] $IsExactly,

        [datetime]$StartTime,
        [datetime]$EndTime, 
        [Parameter()][ValidateRange(5,1440)][int]$IntervalInMinutes=60
    )
    
    begin {
        $_StartsWith = Convert-MSGStartsWith $StartsWith

        $params = @{
            uri = (Get-MSGEndPoint "msGraphBetaSchedule") 
            IsExactly = $IsExactly 
            StartsWith = $_StartsWith 
            Top = $Top
            Select = $Select
            CustomFilter = $CustomFilter
        }

        $Body = @{
            schedules = @()
            startTime = @{
                
            }
            endTime
        }

        $Uri = Format-MSGUri @params -AllRecords:$AllRecords 
    }
    
    process {
        $ReturnValue = Get-MSGObject -uri $Uri -method "Post" -body = $Body -limitedOutput:([bool]$top -and !$AllRecords) 
    }
    end {
        if(!$Select){
            $ReturnValue | ForEach-Object{$_.PSObject.TypeNames.Insert(0,"MSGraph.RoomList")}
        }
        Return $ReturnValue
    }
    
}