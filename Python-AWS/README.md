README file for Linux Installation

**Pre-requisites**

1. Install Python(3.5.x or 3.6.x). Steps given to install 3.5.2, replace it with the required version
    
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

2. Install Required Libraries. Run the following commands on command prompt(For Python 3.5.x)
    
    pip3.5 install requests
    pip3.5 install boto3      

3. Install AWS CLI. Run the following commands on the command prompt(Example give for 3.5)
    
    pip3.5 install awscli --ignore-installed six
    aws help //to make sure aws is installed
    aws configure //to create credentials file. We are not going to use these credentials.

4. Configure AWS(SAML) web App on PAS Portal, [PAS Guide](https://stage-docs.centrify.com/Content/Applications/AppsWeb/AmazonSAML.htm?cshid=1067#Amazon_Web_Services_(SAML))

**Running the program**
Run the command 
Python3.5  CentrifyAWSCLI.py -h [-t|-tenant] <tenant> [-r|-region] <region>

**Please see, [Detailed Reference Doc](https://developer.centrify.com/docs/aws-cli)**
