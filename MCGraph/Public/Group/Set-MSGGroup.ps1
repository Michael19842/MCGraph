function Set-MSGGroup {
    [CmdletBinding(DefaultParameterSetName="Identity", SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity", ValueFromPipeline=$true, Position = 0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object", ValueFromPipelineByPropertyName=$true)] [String] $Id,

        [Parameter(Mandatory = $false)][bool]$allowExternalSenders,
        [Parameter(Mandatory = $false)][bool]$autoSubscribeNewMembers,
        [Parameter(Mandatory = $false)][string]$description,
        [Parameter(Mandatory = $false)][string]$displayName,
        [Parameter(Mandatory = $false)][array]$groupTypes,
        [Parameter(Mandatory = $false)][bool]$mailEnabled,
        [Parameter(Mandatory = $false)][string]$mailNickname,
        [Parameter(Mandatory = $false)][bool]$securityEnabled,
        [Parameter(Mandatory = $false)][bool][ValidateSet("Public","Private")]$visibility,
        [switch] $Force,
        [switch] $PassThru

<#
        allowExternalSenders	Boolean	Default is false. Indicates if people external to the organization can send messages to the group.
autoSubscribeNewMembers	Boolean	Default is false. Indicates if new members added to the group will be auto-subscribed to receive email notifications.
description	String	An optional description for the group.
displayName	String	The display name for the group. This property is required when a group is created and it cannot be cleared during updates.
groupTypes	String collection	Specifies the group type and its membership.

If the collection contains Unified then the group is an Office 365 group; otherwise it's a security group.

If the collection includes DynamicMembership, the group has dynamic membership; otherwise, membership is static.
mailEnabled	Boolean	Specifies whether the group is mail-enabled.
mailNickname	String	The mail alias for the group. This property must be specified when a group is created.
securityEnabled	Boolean	Specifies whether the group is a security group.
visibility	String	Specifies the visibility of an Office 365 group. The possible values are: Private, Public, or empty (which is interpreted as Public).
#> 
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
        
        $body = @{}

        if($allowExternalSenders){$body.allowExternalSenders = $allowExternalSenders}
        if($autoSubscribeNewMembers){$body.autoSubscribeNewMembers = $autoSubscribeNewMembers}
        if($description){$body.description = $description}
        if($displayName){$body.displayName = $displayName}
        if($groupTypes){$body.groupTypes = $groupTypes}
        if($mailEnabled){$body.mailEnabled = $mailEnabled}
        if($mailNickname){$body.mailNickname = $mailNickname}
        if($securityEnabled){$body.securityEnabled = $securityEnabled}
        if($visibility){$body.visibility = $visibility}

        if ($body -ne @{}) {
            Try{
                if ($Force -or $PSCmdlet.ShouldProcess("Azure ActiveDirectory GroupObject $UsedIdentity")) {
                    Return Set-MSGObject -uri (Format-MSGUri -uri $uri) -body $body -Force -PassThru:$PassThru
                }
            } catch [System.UnauthorizedAccessException] {
                Throw [System.UnauthorizedAccessException]::new("403: not authorised, calling entity should at least have Group.ReadWrite.All privilidges")
            }
        }
    }
}