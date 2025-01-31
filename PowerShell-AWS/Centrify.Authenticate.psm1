# Copyright 2021 Centrify Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Import-Module .\Centrify.AWS.SSO.Powershell.psm1 3>$null 4>$null -force
Import-Module .\Centrify.Samples.PowerShell.psm1 3>$null 4>$null -force

function Centrify-Authenticate([string]$Tenant="devdog", [string]$Location) 
{
    Write-Host "`n-----------Centrify SAML Authentication for AWSCli-----------" -foregroundcolor Green
    if ($DebugPreference -eq "Continue") {
         Write-Warning "Debug messaging on. Note that it will log incoming and outgoing REST messages which can contain sensetive information."
    }
	if (!$Tenant -NotLike "https://*") {
    	$Tenant = "https://"+$($Tenant)
	}
    if (!$Region) {
        Write-Host "Using default region us-west-2"
		$Region = "us-west-2"
	}
    if (!$Location) {
        Write-Host "Using following default credential file location"
        $UserHome = $env:USERPROFILE
        $Location = $UserHome + "\.aws\credentials"
        Write-Host $Location
    }
	Write-Host ("Authenticating on " + $Tenant)
    Write-Host("Credentials will be save in " + $Location)
    Centrify-AWS-Authentication $Tenant $Region $Location
	Write-Host "--------------------------COMPLETE---------------------------" -foregroundcolor Green
}

