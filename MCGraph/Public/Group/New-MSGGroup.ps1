function New-MSGGroup {

    <#

    .PARAMETER displayName	
    string	The name to display in the address book for the group. Required.

    .PARAMETER mailEnabled	
    boolean	Set to true for mail-enabled groups. Required.

    .PARAMETER mailNickname	
    string	The mail alias for the group. Required.

    .PARAMETER securityEnabled	
    boolean	Set to true for security-enabled groups, including Office 365 groups. Required.

    .PARAMETER owners	
    string collection This property represents the owners for the group at creation time. Optional.

    .PARAMETER member 
    string collectionThis property represents the members for the group at creation time. Optional.

    #>
    

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        [Parameter(Mandatory = $true)] [string] $DisplayName,
        [Parameter(Mandatory = $false)] [string] $Description,
        [Parameter(Mandatory = $false )] [bool] $MailEnabled = $false,
        [Parameter(Mandatory = $true)] [string] $MailNickname,
        [Parameter(Mandatory = $false)] [bool] $SecurityEnabled = $true,
        [Parameter(Mandatory = $false)] [array] $Owners,
        [Parameter(Mandatory = $false)] [array] $Members
    )
    
    begin {
        $uri = Get-MSGEndPoint -EndPoint "msGraphV1Groups"

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
        $body = @{
            displayName = $DisplayName
            mailEnabled = $MailEnabled
            mailNickname = $MailNickname
            securityEnabled = $SecurityEnabled
        } 
        if ($Description) {$body.Description = $Description}
        #todo: Add $ownsers

        #todo: Add $members
        if ($Force -or $PSCmdlet.ShouldProcess("Azure ActiveDirectory GroupObject $UsedIdentity")) {
            New-MSGObject -uri $uri -body $body -force
        }
    }
    
    end {
        
    }
}

