function Add-MSGGroupMember {
    [CmdletBinding(DefaultParameterSetName="Identity|Object")]
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

        [switch] $PassThru
    )
    
    
    process {
        switch ($PsCmdlet.ParameterSetName) {
            {$_ -match "^Identity"} {
                $UsedIdentity = $Identity 
            }
            {$_ -match "^Object"} {
                $UsedIdentity = $id
            }
        }
        If($UserPrincipalName) {
            $MemberDirectoryObject = Get-MSGUserObject -userPrincipalName $UserPrincipalName
        }

        if($MemberDirectoryObject) {
            $MemberDirectoryObjectId = $MemberDirectoryObject.Id
        }

        $uri = Get-MSGEndPoint -EndPoint "msGraphV1GroupMembersAdd" -EndPointParameters @{Identity = $UsedIdentity}
        
        $body = @{
            "@odata.id" = Get-MSGObjectReference $MemberDirectoryObjectId
        }
                
        Try {
            $RetVal = new-MSGObject -uri $uri -body $body 
        } 
        #Object is already a member
        Catch [System.InvalidOperationException] {
            Write-Warning "Object $MemberDirectoryObjectId is already a member of $Id" 
        }
        Catch {
            Throw $_
        }

        if($PassThru) {
            $RetVal = Get-MSGGroupObject -Identity $UsedIdentity -ExpandMembers
        }
        Return $RetVal
    }
    
}