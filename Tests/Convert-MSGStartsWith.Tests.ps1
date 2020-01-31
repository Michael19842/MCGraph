. "$PSScriptRoot/_DefaultTestStart.ps1"

InModuleScope $ModuleName {
    describe 'Convert-MSGStartWith' {
        $DefaultProperty = "Test"
        Context "When invoked correctly" {
            
            it "should return a hashtable containing the default property if invoked with a string param" {
                (Convert-MSGStartsWith "Test" -DefaultProperty $DefaultProperty) | should -BeOfType [hashtable]
            }
            it "should return a hashtable containing the default property displayname if invoked with a string param" {
                (Convert-MSGStartsWith "Test" -DefaultProperty $DefaultProperty).$DefaultProperty | should -BeExactly "Test"
            }
            it "should return the same hashtable if invoked with a param of type hashtable" {
                (Convert-MSGStartsWith @{$DefaultProperty = "Test"} -DefaultProperty $DefaultProperty).$DefaultProperty | should -BeExactly "Test"
            }
        }

        Context "When invoked incorrectly" {
            it "should return [null] if called with an integer" {
                (Convert-MSGStartsWith 1 -DefaultProperty $DefaultProperty) | should -BeExactly $null
            }
        }
    }
}
