**Introduction**

This is the README file for Centrify offers Python and PowerShell CLI utilities to access Amazon Web Services by leveraging Privileged Access Service. The AWS CLI utilities are available from the Downloads area of the Admin Portal.

**Following platforms are supported**

Windows  
Linux

**Centrify PowerShell utility Installation on Windows**: Please refer to the link :" AWS PowerShell utility: https://developer.centrify.com/docs/aws-powershell-utility-v10 "**

**Pre-requisites**

PowerShell 5.x
Install AWS CLI , steps are given below .
Install AWS PowerShell Module, for this run Command " Install-Module AWSPowerShell "
Run command " Import-Module AWSPowerShell"
Configure AWS(SAML) web App on PAS Portal (Follow the Link : https://stage-docs.centrify.com/Content/Applications/AppsWeb/AmazonSAML.htm?cshid=1067#Amazon_Web_Services_(SAML)) 

**Steps to configure AWS CLI**

Follow the Link https://aws.amazon.com/cli/ to download the windows installer(AWSCLIV2.msi).
Run AWSCLIV2.msi 
It will get installed on path "\absolute_path\Amazon\AWSCLIV2"
Open PowerShell as Administrator
Run Command "aws configure" and provide the credential for making connection with AWS like "aws key id " and "aws secret key access" and region .
After the step 3 the Profiles are stored in the AWS credentials file (path is "C:\Users\Administrator\.aws "). The same profile can be used for AWS CLI as well Powershell commands .

**Steps for Installation of Centrify PowerShell Utility*

Follow the Link : https://developer.centrify.com/docs/centrify-powershell-utility-installation
Download the AWS PowerShell utility zip file.
Unzip the file into a new folder.
Open the Powershell prompt in Administrator mode.
Run command " Set-ExecutionPolicy Unrestricted " to enable the scripts.
Run [System.Net.ServicePointManager]::SecurityProtocol and check for TLS12 in the resulting output.
Run command " .\CentrifyAuthenticate.ps1 –Tenant <Tenant.centrify.com> -Location “\absolute_path\.aws\credentials” ”
Enter your Centrify credentials for authentication. Note: Credentials may be a MFA per user configuration.
Once authenticated, all authorized AWS applications are listed.
Choose an application by entering the number of the application.
Running an application will generate a SAML. The SAML will be posted to AWS for its credentials.
Choose an AWS role.
If the inputs are correct, run AWS command "Get-S3Bucket -ProfileName CentrifyAmazonSSO-944640038399-Profile". Note : Here profile is as per user AWS Role profile .

