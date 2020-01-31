. "$PSScriptRoot/_DefaultTestStart.ps1"

InModuleScope $ModuleName {
    describe  'Convert-MSGStartWith' {
        Context "when invoked correctly" {
            it "should return a string containing msOAuthv2 endpoint when invoked with msOAuthv2 and tenentid" {
                Get-MSGEndPoint	-EndPoint "msOAuthv2" -EndPointParameters @{TenantId = "Test"} | Should -BeExactly "https://login.microsoftonline.com/Test/oauth2/v2.0/token"
            }
            it "should return a string containing msGraphV1Groups endpoint when invoked with msGraphV1Groups" {
                Get-MSGEndPoint	-EndPoint "msGraphV1Groups" | Should -BeOfType [string]
            }
        }
        Context "when invoked incorrectly" {
            it "should throw when invoked with msOAuthv2 and no tenentid" {
                {Get-MSGEndPoint	-EndPoint "msOAuthv2"} | Should throw "{{TenantId}} not supplied!"
            }
        }
    }
}