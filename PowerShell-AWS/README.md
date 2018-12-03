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

Please see https://developer.centrify.com/v1.2/docs/aws-powershell-utility-v10

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

