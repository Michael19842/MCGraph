. "$PSScriptRoot/_DefaultTestStart.ps1"


describe 'Add-MSGGroupMember' {
    
    Context "When invoked correctly" {
        
        
        
        Mock Get-MSGEndPoint {return "https://some.url"} -ModuleName "MCGraph" -Verifiable
        #Mock Get-MSGObjectReference {return "https://some.url"} -ModuleName "MCGraph" -Verifiable -RemoveParameterType 'ObjectType'
        Mock New-MSGObject {return $null} -ModuleName "MCGraph" -Verifiable
        Mock Get-MSGGroupObject {return @{group=$true}} -ModuleName "MCGraph"

        Add-MSGGroupMember -Identity "groupid" -MemberDirectoryObjectId "userobj"
        
        it "should should call all verifiable functions" {
            Assert-VerifiableMock 
        }
        it "should return return null when invoked without passthru param" {
            (Add-MSGGroupMember -Identity "groupid" -MemberDirectoryObjectId "userobj" ) | should -Be $null
        }
        it "should return return ""group"" when invoked without passthru param" {
            (Add-MSGGroupMember -Identity "groupid" -MemberDirectoryObjectId "userobj" -PassThru) | should -BeOfType [hashtable]
        }
    }

    Context "When invoked incorrectly" {
        Mock Get-MSGEndPoint {return "https://some.url"} -ModuleName "MCGraph" -Verifiable
        Mock Get-MSGObjectReference {return "https://some.url"} -ModuleName "MCGraph" -Verifiable
        Mock New-MSGObject {throw [System.InvalidOperationException]::new("401")} -ModuleName "MCGraph" -Verifiable
        Mock Get-MSGGroupObject {return @{group=$true}} -ModuleName "MCGraph"

        it "should not throw if user already exists as a member" {
            Add-MSGGroupMember -Identity "groupid" -MemberDirectoryObjectId "userobj" -PassThru | should -BeOfType [hashtable]
        }

    }
}
