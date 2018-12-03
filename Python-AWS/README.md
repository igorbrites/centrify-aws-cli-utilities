# Installation Guide and Execution Instructions
For Python-AWS

## Prerequisites

### Install Python

>Note: Python 3.5+ is recomended. Linux might already have older Python version, here use Python 3.5.2 as an example. Make sure that you are using Python 3.5.2 if following the example. In the following instructions for linux, this Python is invoked as `Python3.5/pip3.5` command.

#### RHEL

Run the following commands to install Python 3.5.2 on linux

```
    yum install gcc
    cd /opt
    wget https://www.Python.org/ftp/Python/3.5.2/Python-3.5.2.tgz
    tar xzf Python-3.5.2.tgz
    cd Python-3.5.2
    ./configure
    make altinstall
    Python3.5 --version
    pip3.5 –version (version shows 8.1.1)
    pip3.5 install --upgrade pip (version shows 8.1.2)
```

#### Windows

1.  Download appropriate windows installer from https://www.Python.org/downloads/release/Python-352/ and run the installer.
2.  Run the command `pip install --upgrade pip` 

### Install required libraries

Run the following commands on command prompt. 

```
    pip3.5 install requests
    pip3.5 install boto3
```

## Install the AWS CLI

Run the following commands on the command prompt.

```
    pip3.5 install awscli --ignore-installed six
    aws help //to make sure aws is installed
    aws configure //to create credentials file. We are not going to use these credentials.
```

* AWS Access Key ID [None]: ***REMOVED***
* AWS Secret Access Key [None]: ***REMOVED***
* Default region name [None]: us-west-2
* Default output format [None]: text

Check the `credentials` file:

**For Linux**

```
    cat ~/.aws/credentials
```

**For Windows**

Check the contents of `c:/User/<USER_NAME>/.aws/credentials`.

## Edit configuration files

Navigate to the directory contains the CLI and modify the following file:

### Proxy.properties

In this properties file, if your organization uses a proxy server then mention the proxy server details. Else, mention proxy=no.
1.  [Properties]  //Don’t modify
2.  proxy=no //If you are using proxy, modify it as yes
3.  http_proxy= //If you are using proxy, modify with the proxy value
4.  https_proxy= //If you are using proxy, modify with the proxy value
5.  proxy_user= //User for proxy server authentication (and not the centrify instance authentication)
6.  proxy_password=  //If above value is no, and if you are using proxy server then update this value with base64 encoded value of proxy server password

## Create cacerts.pem

Please see https://developer.centrify.com/v1.2/docs/aws-cli

## Running the program

1.  Run the command `Python3.5 CentrifyAWSCLI.py -h [-t|-tenant] <tenant> [-r|-region] <region>`

**Command line arguments**

a.  `-h / -help`
Provides help for the program.

```
> Python CentrifyAWSCLI.py -h
usage: CentrifyAWSCLI.py [-h] [-tenant TENANT] [-region REGION] [-debug]

Enter Centrify Credentials and choose AWS Role to create AWS Profile. Use this
AWS Profile to run AWS commands.

optional arguments:
  -h, --help            show this help message and exit
  -tenant TENANT, -t TENANT
                        Enter tenant url or name e.g. cloud.centrify.com or
                        cloud
  -region REGION, -r REGION
                        Enter AWS region. Default is us-west-2
  -debug, -d            This will make debug on
```

b.  `-t / -tenant`
The tenant parameter can be used in the following way. If the value is not provided, then the default value is cloud.centrify.com

```
> Python CentrifyAWSCLI.py -t cloud 
```

OR

```
> Python CentrifyAWSCLI.py -t cloud.centrify.com
```

OR 

```
> Python CentrifyAWSCLI.py -tenant station 
```

c.  `-r / -region`
You can specify AWS region in the following way. If the value is not provided, then the default value is us-west-2

```
> Python CentrifyAWSCLI.py -t cloud -r ap-southeast-1
```

OR

```
> Python CentrifyAWSCLI.py -t cloud -region ap-southeast-1
```

d.  `-d / -debug`
Makes debug ON. This makes program logs input request with the values. It may log sensitive data.

```
> Python CentrifyAWSCLI.py -t cloud -d
```

OR

```
> Python CentrifyAWSCLI.py -t cloud -r ap-southeast-1 -d
```

2.  The tenant name can be either only “cloud” or “cloud.centrify.com”. In these cases, the cacerts file should be named as “cacerts_cloud.pem”. If the tenant name is “mytenant.somedomain.centrify.com” then the cacerts filename should be `cacerts_mytenant.pem`
3.  Give username for Centrify instance.
4.  If proxy server is used and proxy_ask_password option is ‘yes’, then it will be asked. Enter that value.
5.  Enter Centrify instance password.
6.  Choose role by entering the number from the options e.g. 1
7.  The credential file will be updated with saml profile
8.  You can use the profile name to run the AWS command e.g. `aws s3 ls --profile <profile_name>`
