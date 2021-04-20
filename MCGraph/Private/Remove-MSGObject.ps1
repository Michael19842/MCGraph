function Remove-MSGObject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)][string] $uri,
        [switch] $raw, 
        [switch] $Force
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
        $method = "DELETE"
    }
    
    
    process {
        if ($Force -or $PSCmdlet.ShouldProcess("$method : $uri")) {
            return Invoke-MSGWebRequest -method $method -uri $uri -Force:$Force
        }
    }
}