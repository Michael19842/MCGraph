. "$PSScriptRoot/_DefaultTestStart.ps1"


describe -tag 'build' 'Convert-MSGStartWith' {
    InModuleScope $ModuleName {
        it "should return the valid uri for http://www.test.nl with all params set" {
            (Format-MSGUri -uri "http://www.test.nl" `
            -IsExactly @{test = "test";test2 = "test2"} `
            -StartsWith @{test="test";test2 = "test2"} `
            -Top 1 `
            -Skip 2 `
            -Select Test1,Test2,Test3 ) | should -be 'http://www.test.nl?$filter=test eq ''test'' and test2 eq ''test2'' and startswith(test,''test'') and startswith(test2,''test2'')&$select=Test1%2cTest2%2cTest3&$top=1&$skip=2'
            }
    it "should return a valid uri with a CustomFilter" {
            (Format-MSGUri -uri "http://www.test.nl" `
            -CustomFilter "test eq 'OK'" ) | should -Be 'http://www.test.nl?$filter=test eq ''OK'''
            }
    }
}
