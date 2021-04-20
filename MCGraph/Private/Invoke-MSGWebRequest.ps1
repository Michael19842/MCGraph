
function Invoke-MSGWebRequest {
    [CmdletBinding(SupportsShouldProcess)]
    
    param (
        [Parameter(Mandatory = $true)] [ValidateSet('get', 'set', 'patch', 'post', 'delete')] $method, 
        [Parameter(Mandatory = $true)] [ValidateScript ( { Test-MSGWebUri -address $_ })]$uri,
        [Parameter(Mandatory = $false )] $body,
        [Parameter(Mandatory = $false )] $contentType = "application/json",
        [Parameter(Mandatory = $false )] [hashtable] $Headers,
        [switch] $limitedOutput,
        [switch] $Raw,
        [switch] $NoAuthorization, 
        [switch] $Force
    )
    
    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
        [Token]$token = $Session.getToken()
    }
    
    process {
        Write-Verbose "method: $method"
        Write-Verbose "contentType: $contentType"
        
        If (!$Session.Token.Valid -and $uri -notmatch "oauth2") {
            throw "No valid session"
        }
        
        if (!$Headers) { $Headers = @{ } } 

        if (!$NoAuthorization) {
            If (!$Headers.Authorization) { 
                $Headers.Authorization = "Bearer $($token.value)" 
            }
        }

        Write-Verbose (ConvertTo-Json $Headers)

        
        if ($contentType -match "json" -and $body -is [hashtable]) {
            $body = ConvertTo-Json $body -Compress -Depth 10
        }
        if ($contentType -match "urlencoded" -and $body -is [hashtable]) {
            $body = ($body.keys | % { "$([System.Web.HttpUtility]::UrlEncode($_))=$([System.Web.HttpUtility]::UrlEncode($body.$_))" }) -join "&"
        }
        if ($body) { Write-Verbose "body:$($body |convertto-json)" }


        if ($Force -or $PSCmdlet.ShouldProcess("$uri")) {


            $request = [system.net.webrequest]::Create($uri)
            $request.Method = $method
            
            foreach ($Key in $Headers.Keys | ? { $_ -notin @("host", "accept") }) {
                $request.Headers.Add($key, $Headers.$Key)
            } 
            if ($Headers.Host) {
                $request.Host = $Headers.Host
            }
            if ($Headers.Accept) {
                $request.Accept = $Headers.Accept
            }
            $request.ContentType = $contentType
            $request.Timeout = 10000;
            
            if ($Session.ProxySettings) {
                $request.Proxy = [System.Net.WebProxy]::new($Session.ProxySettings.Address)
                $request.Proxy.Credentials = $Session.ProxySettings.Credential
            }

            if ($body) {
                #Build the requestbody
                $Bytes = [System.Text.Encoding]::Default.GetBytes($body)
                $request.ContentLength = $Bytes.Length
                $Stream = $request.GetRequestStream()
                $Stream.Write($Bytes, 0, $Bytes.Length);
                
                $Stream.Flush();
                $Stream.Close();
            }
        
            try {
                $Response = $request.GetResponse()
                $ResponseStream = $Response.GetResponseStream()
                $SteamReader = New-Object System.IO.StreamReader($ResponseStream)
                           
                $ResponseObject = @{
                    BaseResponse = $Response
                    Content      = $SteamReader.ReadToEnd() 
                    Request      = $request
                    Session      = $IDM_Session
                }
            }
            catch [System.Net.WebException] {
                Throw $_.Exception.response
                $ResponseObject = @{
                    BaseResponse = $_.Exception.response
                    Content      = $_.Exception.Message
                    Request      = $request
                    Session      = $IDM_Session
                }
            }
            
            $Global:MSGLatestReponse = $ResponseObject
        }

        Switch ($ResponseObject.BaseResponse.StatusCode.Value__) {
            <#
                    200 OK
                    201 Created
                    202 Accepted
                    203 Non-Authoritative Information
                    204 No Content
                #>
            { $_ -in @(200, 201, 202, 203, 204) } {
                if ($ResponseObject.Content) {
                    $responseContent = ConvertFrom-Json $ResponseObject.Content
                    if ($responseContent."@odata.context" -match '\$entity$' -or $responseContent.token_type ) {
                        if (!$raw) { $responseContent.PSObject.properties.remove('@odata.context') }
                        return $responseContent
                    }
                    else {
                        $list = @()
                        $list += $responseContent.value
                        if (!$limitedOutput) {
                            if ($responseContent."@odata.nextLink") {
                                $list += (Get-MSGObject $responseContent."@odata.nextLink")
                            }
                        }
                        return $list
                    }
                }
            
                else {
                    return @{ }
                }
            }
            default {
                throw [System.InvalidOperationException]::new("$($responseObject.BaseResponse.StatusCode.Value__):: $($ResponseObject.Content)")
            }
        }
    }

    
    end {
    }
}
        

# function Invoke-MSGWebRequest {
#     [CmdletBinding(SupportsShouldProcess)]
    
#     param (
#         [Parameter(Mandatory = $true)] [ValidateSet('get', 'set', 'patch', 'post', 'delete')] $method, 
#         [Parameter(Mandatory = $true)] [ValidateScript ( { Test-MSGWebUri -address $_ })]$uri,
#         [Parameter(Mandatory = $false )] [string] $body,
#         [Parameter(Mandatory = $false )] $contentType = "application/json",
#         [switch] $limitedOutput,
#         [switch] $Raw,
#         [switch] $Force
#     )
    
#     begin {
#         if (-not $PSBoundParameters.ContainsKey('Verbose')) {
#             $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
#         }
#         if (-not $PSBoundParameters.ContainsKey('Confirm')) {
#             $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
#         }
#         if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
#             $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
#         }

#         [Token]$token = $Session.getToken()
#     }
    
#     process {
#         Write-Verbose "method: $method"
#         Write-Verbose "contentType: $contentType"

#         if ($body) { Write-Verbose "body:$(ConvertTo-Json $body)" }

#         if ($Force -or $PSCmdlet.ShouldProcess("$uri")) {
#             $response = try {
                

#                 $InvokeParams = @{
#                     Method          = $method 
#                     Uri             = $uri 
#                     ContentType     = $contentType 
#                     Headers         = @{Authorization = "Bearer $($token.value)" } 
#                     UseBasicParsing = $true 
#                 }
#                 if ($Session.ProxySettings) {
#                     $InvokeParams.Proxy = $Session.ProxySettings.Address
#                     $InvokeParams.ProxyCredential = $Session.ProxySettings.Credential
#                 }


#                 if ($body) {
#                     $InvokeParams.Body = $body
#                     (Invoke-WebRequest @InvokeParams -ErrorAction  Stop)
#                 }
#                 else {
#                     (Invoke-WebRequest @InvokeParams -ErrorAction Stop)
#                 }
#             }
#             catch [System.Net.WebException] {
#                 Write-Verbose "An exception was caught: $($_.Exception.Message)"
#                 @{
#                     BaseResponse = $_.Exception.Response
#                     Exception    = $_
#                 }
#             }

#             Switch ($response.BaseResponse.StatusCode.Value__) {
#                 <#
#                     200 OK
#                     201 Created
#                     202 Accepted
#                     203 Non-Authoritative Information
#                     204 No Content
#                 #>
#                 { $_ -in @(200, 201, 202, 203, 204) } {
#                     if ($response.Content) {
#                         $responseContent = ConvertFrom-Json $response.Content

#                         if ($responseContent."@odata.context" -match '\$entity$') {
#                             if (!$raw) { $responseContent.PSObject.properties.remove('@odata.context') }
#                             return $responseContent
#                         }
#                         else {
#                             $list = @()
#                             $list += $responseContent.value
#                             if (!$limitedOutput) {
#                                 if ($responseContent."@odata.nextLink") {
#                                     $list += (Get-MSGObject $responseContent."@odata.nextLink")
#                                 }
#                             }
#                             return $list
#                         }
#                     }
#                     else {
#                         return @{ }
#                     }
#                 }
#                 { $_ -in @(400) } {
#                     $ErrorDetails = ConvertFrom-Json $response.Exception.ErrorDetails
#                     throw [System.InvalidOperationException]::new("$($response.BaseResponse.StatusCode.Value__):: $($ErrorDetails.Error.Message)")
#                 }
#                 { $_ -in @(403) } {
#                     $ErrorDetails = ConvertFrom-Json $response.Exception.ErrorDetails
#                     throw [System.UnauthorizedAccessException]::new("$($response.BaseResponse.StatusCode.Value__):: $($ErrorDetails.Error.Message)")
#                 }
#                 { $_ -in @(404) } {
#                     $ErrorDetails = ConvertFrom-Json $response.Exception.ErrorDetails
#                     throw [System.Exception]::new("$($response.BaseResponse.StatusCode.Value__):: $($ErrorDetails.Error.Message)")
#                 }
#                 default {
#                     throw "unexpected error $($response.BaseResponse.StatusCode.Value__)"
#                 }
#             }
#         }
#     }
    
#     end {
        
#     }
# }
        