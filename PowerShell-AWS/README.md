
**Centrify PowerShell utility Installation on Windows**: Please refer to the link :[Powershell Installation Guide](https://developer.centrify.com/docs/aws-powershell-utility-v10)

**Pre-requisites**

1. PowerShell 5.x  
2. Install AWS CLI , steps are given below .  
3. Install AWS PowerShell Module, for this run Command " Install-Module AWSPowerShell "  
4. Run command " Import-Module AWSPowerShell"  
5. [Configure AWS(SAML) web App on PAS Portal](https://docs.centrify.com/Content/Applications/AppsWeb/AmazonSAML.htm)

**Steps to configure AWS CLI**

1. Follow the Link https://aws.amazon.com/cli/ to download the windows installer(AWSCLIV2.msi).  
2. Run AWSCLIV2.msi   
3. It will get installed on path "\absolute_path\Amazon\AWSCLIV2"  
4. Open PowerShell as Administrator  
5. Run Command "aws configure" and provide the credential for making connection with AWS like "aws key id " and "aws secret key access" and region .  
6. After the step 5 the Profiles are stored in the AWS credentials file (path is " USER_HOME/.aws/credentials"). The same profile can be used for AWS CLI as well Powershell commands .  

**Steps for Installation of Centrify PowerShell Utility**

1. Follow the Link : https://developer.centrify.com/docs/centrify-powershell-utility-installation  
2. Download the AWS PowerShell utility zip file.  
3. Unzip the file into a new folder.  
4. Open the Powershell prompt in Administrator mode.  
5. Run command " Set-ExecutionPolicy Unrestricted " to enable the scripts.  
6. Run [System.Net.ServicePointManager]::SecurityProtocol and check for TLS12 in the resulting output.  
7. Run command " .\CentrifyAuthenticate.ps1 –Tenant <Tenant.centrify.com> -Location “ USER_HOME/.aws/credentials” ”  
8. Enter your Centrify credentials for authentication. Note: Credentials may be a MFA per user configuration.  
9. Once authenticated, all authorized AWS applications are listed.  
10. Choose an application by entering the number of the application.  
11. Running an application will generate a SAML. The SAML will be posted to AWS for its credentials.  
12. Choose an AWS role.  
13. If the inputs are correct, run AWS command "Get-S3Bucket -ProfileName CentrifyAmazonSSO-944640038399-Profile". Note : Here profile is as per user AWS Role profile . 
