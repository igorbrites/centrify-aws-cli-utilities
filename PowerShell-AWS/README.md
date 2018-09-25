# AWS Powershell Utility

## Highlights

1.  The profiles are stored in the AWS credentials file. Same profile can be used from AWS CLI as well Powershell commands.
2.  AWS Apps list are sorted by its name.
3.  Role list is sorted.
4.  Profile name contains the account number. The multiple profiles with the same name on multiple AWS accounts can be differentiated.

## Prerequisite

1.  Install AWS Cli https://aws.amazon.com/cli/
2.  Run `aws configure` – Refer “Getting started” Section in above AWS documentation. and configure the credentials to create the aws credential file. 
3.  Install the AWS Powershell kit from https://aws.amazon.com/powershell/

## Centrify Powershell Utility Installation

1.  Download the AWS powershell utility zip file.
2.  Create a folder and unzip the file.
3.  Open Powershell prompt in Administrator mode.
4.  Run `Set-ExecutionPolicy Unrestricted` so that you can run the scripts.
5.  Run [System.Net.ServicePointManager]::SecurityProtocol and check for TLS12 in the output. If there is no TLS12 in the protocol list, run the below commands.
* $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
* [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
6.  If you are working behind the proxy server, then please look at the next section.
7.  Run `.\CentrifyAuthenticate.ps1 –Tenant <Tenant.centrify.com> -Location “\absolute_path\aws\credentials”` or `.\ca.ps1 -Tenant <Tenant.centrify.com> -Location “\absolute_path\aws\credentials”` (for shorter version)
a.  Both parameters are optional
b.  Tenant by default points to devdog.centrify.com
c.  Default AWS region need to be set by different command. See the point no 14
d.  Location specifies the absolute path of AWS credentials file.
e.  If location is not specified then it uses default location “USER_HOME/.aws/credentials”
8.  Enter Centrify credentials for authentication. It might be MFA as per user configuration.
9.  Once user is authenticated, all the AWS applications which user is authorized to run are listed.
10. Choose application by entering the number.
11. Running the application will generate SAML which will be posted to AWS for its credentials. 
12. Choose AWS role.
13. If your inputs are right, AWS credentials will be saved in the profile `<ProfileName>`. You can use the `<ProfileName>` to run the AWS commands.
e.g. `Get-S3Bucket -ProfileName <ProfileName>`
14. If you would like to set your default region, use the following AWS commands.
`Set-DefaultAWSRegion -Region <region>`
Where region = `us-east-1`, `us-west-1` etc.

## Working behind a proxy server

Run the following commands to enable your Powershell session to use the proxy credentials.

```
    webclient=New-Object System.Net.WebClient
    creds=Get-Credential
    webclient.Proxy.Credentials=$creds
```

## Logging – Verbose output
Run command 

```
    VerbosePreference=”Continue”
```

to see the verbose output. To set it off, run 

```
    VersbosePreference=”SilentlyContinue”
```

## Supported Version
This Powershell utility is tested on following AWS Powershell tool version.
AWS Tools for Windows PowerShell
Version 3.3.197.0
 
Amazon Web Services SDK for .NET
Core Runtime Version 3.3.20.0 

