function Remove-MSGGroupMember {
    [CmdletBinding(DefaultParameterSetName="Identity|Object", SupportsShouldProcess)]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true,ParameterSetName = "Identity|Object", ValueFromPipeline=$true, Position = 0)]
        [Parameter(Mandatory = $true,ParameterSetName = "Identity|ObjectId", ValueFromPipeline=$true, Position = 0)]
        [Parameter(Mandatory = $true,ParameterSetName = "Identity|UserPrincipalName", ValueFromPipeline=$true, Position = 0)][String] $Identity,
        [Parameter(Mandatory = $false,ParameterSetName = "Object|Object", ValueFromPipelineByPropertyName=$true)] 
        [Parameter(Mandatory = $false,ParameterSetName = "Object|ObjectId", ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory = $false,ParameterSetName = "Object|UserPrincipalName", ValueFromPipelineByPropertyName=$true)][String] $Id,
    
        [Parameter(Mandatory = $false,ParameterSetName = "Object|Object")]
        [Parameter(Mandatory = $false,ParameterSetName = "Identity|Object")][String] $MemberDirectoryObjectId,
        [Parameter(Mandatory = $false,ParameterSetName = "Object|ObjectId")]
        [Parameter(Mandatory = $false,ParameterSetName = "Identity|ObjectId")][system.Object] $MemberDirectoryObject,
        [Parameter(Mandatory = $false,ParameterSetName = "Object|UserPrincipalName")]
        [Parameter(Mandatory = $false,ParameterSetName = "Identity|UserPrincipalName")][String] $UserPrincipalName,

        [switch] $PassThru,
        [switch] $Force
    )
    
    
    process {
        switch ($PsCmdlet.ParameterSetName) {
            {$_ -match "^Identity|"} {
                $UsedIdentity = $Identity
            }
            {$_ -match "^Object|"} {
                $UsedIdentity = $id
            }
        }
        If($UserPrincipalName) {
            $MemberDirectoryObject = Get-MSGUserObject -userPrincipalName $UserPrincipalName
        }

        if($MemberDirectoryObject) {
            $MemberDirectoryObjectId = $MemberDirectoryObject.Id
        }

        $uri =Get-MSGEndPoint -EndPoint "msGraphV1GroupMembersRemove" -EndPointParameters @{GroupIdentity = $UsedIdentity; UserIdentity = $MemberDirectoryObjectId}
        
        if ($Force -or $PSCmdlet.ShouldProcess("$uri")) {
            Try {
                $RetVal = Remove-MSGObject -uri $uri 
            } 
            Catch {
                Throw $_
            }
        }   
        if($PassThru) {
            $RetVal = Get-MSGGroupObject -Identity $UsedIdentity -ExpandMembers
        }
        Return $RetVal
    }
    
}