function Disconnect-MSGAppRegistration {
    [CmdletBinding()]
    param (
        
    )
    
    process {
        $script:Session = [Session]::new()
        Write-Verbose "Disconnected the active session with MS-Graph"
    }

}


