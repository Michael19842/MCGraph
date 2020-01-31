. "$PSScriptRoot/_DefaultTestStart.ps1"

describe 'Confirm-MSGStartWithParamType' {
    InModuleScope $ModuleName {
        it "should return true if is invoked with a param of type string" {
            (Confirm-MSGStartWithParamType "Test") | should -be $true
        }
        it "should return true if is invoked with a param of type hashtable" {
            (Confirm-MSGStartWithParamType @{Test="Test"}) | should -be $true
        }
        it "should return false if is invoked with a param of type int" {
            {Confirm-MSGStartWithParamType 1} | Should Throw
        }
        it "should return false if is invoked with a param of type boot" {
            {Confirm-MSGStartWithParamType $true} | Should Throw
        }
    }
}
