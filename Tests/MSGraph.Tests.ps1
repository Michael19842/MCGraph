. "$PSScriptRoot/_DefaultTestStart.ps1"

Describe "MCGraph-Module" {
    Context "Endpoints file" {
        $EndPointsFile = Resolve-Path "$ModuleRoot\Private\Endpoint\EndPoints.json"
        
        it "Test if the endpointsfile exists" {
            [System.IO.File]::Exists($EndPointsFile) | Should -be $true
        }

        $EndPointsFileContent = Get-Content $EndPointsFile

        It "Test is the endpointsfile contains Valid JSON" {
            ($EndPointsFileContent |ConvertFrom-Json -ErrorAction SilentlyContinue) | Should -Not -Be $null
        }

        $EndPoints = ($EndPointsFileContent | ConvertFrom-Json)

        foreach ($Property in $EndPoints.psObject.Properties) {
            It "Test $($Property.Name) should be a string"   {
                $Property.value.psObject.TypeNames | Should -Contain "System.String"
            }
            It "Test $($Property.Name) should be a uri"   {
                {[System.Uri]::new($Property.value).Host} | Should -not -Throw
            }
        }
    }
}

