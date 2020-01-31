function Remove-MSGGroup {
    [CmdletBinding(DefaultParameterSetName="Identity", SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position = 0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,
        
        [Parameter(Mandatory = $false,Position =1)] [array] $Select
    )
    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
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
        

        Try{
            if ($Force -or $PSCmdlet.ShouldProcess("Azure ActiveDirectory GroupObject $UsedIdentity")) {
                Return Remove-MSGObject -uri (Format-MSGUri -uri $uri -Select $Select) -Force
            }
        } catch [System.UnauthorizedAccessException] {
            Throw [System.UnauthorizedAccessException]::new("403: not authorised, calling entity should at least have [Group.ReadWrite.All] privilidges")
        }
    }
}