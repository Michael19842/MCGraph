function New-MSGObject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)][string] $uri,
        [Parameter(Mandatory = $false)][hashtable] $body,
        [switch] $raw,
        [switch] $Force,
        [switch] $PassThru
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

        $method = "post"
    }

    process {
        $bodyString =  if($raw){$body}else{ConvertTo-Json -InputObject $body -Compress} 
        if ($Force -or $PSCmdlet.ShouldProcess("$uri")) {
            $retval = Invoke-MSGWebRequest -method $method -uri $uri -body $bodyString -Force:$Force
        }
        if($PassThru){
            $retval = return Invoke-MSGWebRequest -method "get" -uri $uri -Force:$Force
        }
        Return $retval
    }
}
