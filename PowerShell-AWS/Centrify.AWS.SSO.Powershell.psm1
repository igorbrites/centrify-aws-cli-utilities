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

$global:SamlResp = "";
$global:saml="";
$global:attrValueList;
$global:roleChoice="";
$global:Me;


function GetAWSApps {
	[CmdletBinding()] 
	param(
		[string]$username, 
		$token
	) 
    $restArg = @{};
    Write-Host("Invoking getupdata")
	$restResult = Centrify-InvokeREST -Method "/uprest/getupdata" -Endpoint $token.Endpoint -Token $token.BearerToken -IncludeSessionInResult $True
    Write-Host("Invokation complete")
	$awsapps = $restResult.RestResult.Result.Apps.where{($_.TemplateName -Like "*Amazon*" -Or $_.TemplateName -Like "*AWS*") -And $_.WebAppType -ne "UsernamePassword"}
    Write-Host("Received AWS Apps " + $awsapps)
	$global:websession = $restResult.websession
	$awsapps = $awsapps | sort -Property Name

	return $awsapps;
}

function SelectAWSApp {
	[CmdletBinding()] 
	param(
		$awsapps
	) 
    Write-Host("Select the aws app to login. Type 'quit' or 'q' to exit")
	$count = 1
	foreach ($app in $awsapps) {
		Write-Host ("$count  : " + $app.DisplayName + " | " + $app.AppKey);
		$count = $count + 1;
	}
	$selection = Read-Host ("Enter Number ")
	return $selection
}

function ExtractRoles {
	[CmdletBinding()] 
	param(
		$responseHtml
	)

	$start = $responseHtml.IndexOf("value=");
	$end = $responseHtml.IndexOf("/>");
	$global:saml = $responseHtml.Substring($start+7, $end - ($start+7+2));

	$decodeBase64=[xml][System.Text.Encoding]::UTF8.GetString(([System.Convert]::FromBase64String($saml)|?{$_}));
	$global:attrValueList=$decodeBase64.DocumentElement.Assertion.AttributeStatement.Attribute;

	$roleArray = [System.Collections.ArrayList]@()
	$flag = $false
	for($x = 0; $x -lt $attrValueList.Count; $x++)
	{
        $currentAttrValue = @()
		if($attrValueList[$x].Name -eq 'https://aws.amazon.com/SAML/Attributes/Role')
		{
			[array]$currentAttrValue = $attrValueList[$x].AttributeValue;
			for ($roleIndex = 0; $roleIndex -lt $currentAttrValue.count; $roleIndex++) {
				$stringStart = 0;
				$stringEnd = $currentAttrValue[$roleIndex].IndexOf(",");
				$currentRole = $currentAttrValue[$roleIndex].SubString($stringStart, $stringEnd)
				[void]$roleArray.Add($currentRole)
			}
			if (! $flag) {
				$stringStart = $currentAttrValue[0].IndexOf(",") + 1;
				$stringEnd = $currentAttrValue[0].length - $stringStart;
				$global:principle = $currentAttrValue[0].SubString($stringStart, $stringEnd);
				$flag = $true;
			}
		}
	}
    return $roleArray
}

function ChooseRole {
	[CmdletBinding()] 
	param(
		[array]$roleArray
	)

	$count = 1
    $no_of_roles = $roles.count
    $roleArray = $roleArray | sort
	Write-Host "-------------------------------------------------------------";
    Write-Host("Select a role to login. Choose one role at a time. This") -ForegroundColor Green
	Write-Host("selection might be displayed multiple times to facilitate") -ForegroundColor Green
	Write-Host("multiple profile creations. ") -ForegroundColor Green
	Write-Host "Type 'quit' or 'q' to exit." -ForegroundColor Green
	Write-Host "You have following roles to choose - ";
	foreach($element in $roleArray) {
		Write-Host "$($count).$($element)"
		$count++;
	}
    if ($no_of_roles -eq 1) {
        Write-Host ("Choosing above role..")
        $roleChoice = 1
    }
    else {
	    $roleChoice = Read-Host -Prompt "Please choose your role - ";
    }
    try {
	    $intRoleChoice = [int]$roleChoice
	}
	catch {
        throw "Not a number"
	}

	if (($intRoleChoice -ge $count) -or ($intRoleChoice -eq 0)) {
#		Write-Host "Please choose correct value."
        throw "Wrong Input"
	}
	$roleChoiceValue = $roleArray[$intRoleChoice - 1];
	Write-Host "Principle : " $principle
	Write-Host "Role : " $roleChoiceValue
    return $roleChoiceValue
}

function WriteXmlToScreen ([xml]$xml)
{
    $StringWriter = New-Object System.IO.StringWriter;
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter;
    $XmlWriter.Formatting = "indented";
    $xml.WriteTo($XmlWriter);
    $XmlWriter.Flush();
    $StringWriter.Flush();
    Write-Output $StringWriter.ToString();
}

#function Elevate($Uri, $elevate, $challenge) {
#	$jsonContent = @{elevate=$elevate;challengeId=$challenge} #

	#$response = Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Method Post -Body $jsonContent -WebSession $websession
#}

function HandleAppClick ($app, $username) {
		$centrifyJSONFunction = "/uprest/handleAppClick?appkey="+$app.AppKey;
		$Uri=$token.Endpoint+$centrifyJSONFunction
		Write-Host("Calling " + $Uri);	
		
		$jsonContent = "[]"
		$responseHtml = Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Method Post -Body $jsonContent -WebSession $websession -MaximumRedirection 0 -ErrorAction SilentlyContinue -ErrorVariable RedirectionError
		
		if ($RedirectionError) {
			Write-Host "Probably need to elevate."
			$global:webresponse = Invoke-WebRequest -Method POST -Uri $Uri -Websession $websession -MaximumRedirection 0 -ErrorAction SilentlyContinue -ErrorVariable WebReqError;
			Write-Host "Getting challange id"
            $redirectLocation = $webresponse.Headers.Location
            
			$global:queryData = [System.Web.HttpUtility]::ParseQueryString($redirectLocation)
			$elevate = $queryData['elevate']
			$challenge = $queryData['challengeId']
			Write-Host "Calling Elevate... "

			$elevateResult = Centrify-Elevate -Token $token -Challenge $challenge -Elevate $elevate -Username $username
            Write-Host "Received Elavate result"

		    $restMsg = @{}
		    $restMsg.ChallengeStateId = $challenge
		
		    $global:restJsonMsg = $restMsg | ConvertTo-Json
		    $global:addHeaders = @{ 
			    "X-CENTRIFY-NATIVE-CLIENT" = "1"
		    }
		    $addHeaders.Authorization = "Bearer " + $elevateResult.BearerToken
		    $addHeaders."X-CFY-CHALLENGEID" = $challenge
            Write-Host ("Calling " + $Uri)
		    Write-Host $addHeaders
		    Write-Host $restJsonMsg
		
		    $responseHtml = Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Method Post -Body $restJsonMsg -Headers $addHeaders

		}
		
		if (!$responseHtml) {
			Write-Warning "Could not received SAML.. Exiting..";
			Exit 1;
		}  
		Write-Host "Received SAML Response..";
		#Write-Host ("HTML : " + $responseHtml)
        return $responseHtml
}

function Centrify-AWS-Authentication ($Tenant, $Region, $Location)
{
	$endpoint = $Tenant
    $username = Read-Host -Prompt "`nEnter username to authenticate ";
    
    # Authenticating User to Centrify tenant
    Write-Host "Initiating SSO for AWS through $endpoint for $username";
	try {
		$token = Centrify-InteractiveLogin-GetToken -Username $username -Endpoint $endpoint;
	}
	catch {
		$ErrorMessage = $_.Exception.Message
		Write-Host "Something went wrong .. "
		Exit
	}

    # Getting Amazon Web Services (AWS) Console app from tenant 
	Write-Host ("Getting Applications for " + $username)
    try {
	    $awsapps = GetAWSApps $username $token;
    }
    catch {
        $ErrorMessage = $_.Exception.Message
		Write-Host $ErrorMessage -ForegroundColor Red
		Exit
    }
    $arrapps = @()
    $arrapps+=$awsapps
	$profileCount = 0
    $apprun = $false #count of running app when there is only one app in the array.
    if ($arrapps.count -eq 0) {
        Write-Host "There are no AWS apps on the user portal. Exiting.." -ForegroundColor Green
        Exit
    }
	
    while($true) {
        Write-Host "Selecting AWS Apps"
        if ($arrapps.count -eq 1) {
            if ($apprun) {
	    		Write-Host "Exiting...";
                  break
            }
            $selection = 1
            $app = $awsapps[0]
            Write-Host ("Running App..");
            Write-Host ($app.DisplayName + " | " + $app.AppKey);
            $apprun = $true
        }
        else {
		    $selection = SelectAWSApp $awsapps
        }
        
		try {
			$input = [int]$selection
		}
		catch {
			Write-Host "Exiting...";
			Return
		}
		if (($input -gt $arrapps.count) -or ($input -eq 0)) {
			continue;
		}
		
		$app = $awsapps[$input - 1]
		$responseHandleApp = HandleAppClick $app $username
        
        Write-Host "Choosing role based on the received SAML"

        while ($true) {
		    try {
			    [array]$roles = ExtractRoles $responseHandleApp
		    }
		    catch {
				$ErrorMessage = $_.Exception.Message
				Write-Host $ErrorMessage -ForegroundColor Red
			    Write-Host "Probably the SAML token received is not correct....Exiting.." -ForegroundColor Red
                Exit
		    }
            $no_of_roles = $roles.count
            try {
                $roleChoiceValue = ChooseRole $roles
            }
            catch {
                Write-Host "Quitting Role Selection..."
                break;
            }

		    Write-Host "Sending SAML to AWS..";   
		    Write-Host ("Role : " + $roleChoiceValue + " Principle : " + $principle + " Region : " + $Region)
			try {
				$AwsCredentials = Use-STSRoleWithSAML -RoleArn $($roleChoiceValue).ToString() -PrincipalArn $principle -SAMLAssertion $saml -Region $Region;
			}
			catch {
				$ErrorMessage = $_.Exception.Message
				Write-Host $ErrorMessage -ForegroundColor Red
                if ($no_of_roles -eq 1) {
                    break
                }
                else {
    				Continue
                }
			}
		    $profileStr = "Profile"
            $rolesplit = $roleChoiceValue.split("/")
            $roleforprofile = $rolesplit[1]
            $accountsplit = $roleChoiceValue.split(":")
            $accountforprofile = $accountsplit[4]
            $profileName = "$roleforprofile-$accountforprofile-$profileStr"
		    Set-DefaultAWSRegion -Region $Region
		    if ($AwsCredentials) {
			    $global:Me = $AwsCredentials.Credentials
                try {
					Set-AWSCredential -AccessKey $AwsCredentials.Credentials.AccessKeyId -SecretKey $AwsCredentials.Credentials.SecretAccessKey -SessionToken $AwsCredentials.Credentials.SessionToken -StoreAs $ProfileName -ProfileLocation $Location
                }
                catch {
                    $ErrorMessage = $_.Exception.Message
                    Write-Host $ErrorMessage
                    Exit
                }
			
			    Write-Output "-------------------------------------------------------------";
			    Write-Output ("Successful - Use `$profileName Object to Run the commands.");
			    Write-Output ("E.g. Get-S3Bucket -ProfileName " + $ProfileName
			    );
			    Write-Output "-------------------------------------------------------------";
				$AwsCredentials = $null
				$profileCount = $profileCount + 1
                if ($no_of_roles -eq 1) {
                    break
                }
		    }
		    else {
			    Write-Output "No Credentials Received .. Something went wrong..";
		    }
        }
	}
}

Export-ModuleMember -function Centrify-AWS-Authentication

