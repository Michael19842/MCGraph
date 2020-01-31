function Get-MSGObject {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)][string] $uri,
        [switch] $limitedOutput,
        [switch] $raw,
        [Parameter(Mandatory = $false)][string] $method = "get",
        [Parameter(Mandatory = $false)][hashtable] $body
    )

    begin {
        
    }

    process {
        if ($body -and $method -in @('Patch','Put','Post')){
            return Invoke-MSGWebRequest -method $method -uri $uri -body $body -limitedOutput:$limitedOutput} 
        else {
            return Invoke-MSGWebRequest -method $method -uri $uri -limitedOutput:$limitedOutput
        }
    }
}
