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

import boto3
from botocore.exceptions import ClientError
from os.path import expanduser
import configparser
import sys
import logging
import re

def write_cred(cred, count, display_name, region, role):
    display_name = re.sub('\W', '', display_name)
    display_name = re.sub('(.)([A-Z][a-z]+)', r'\1-\2', display_name)
    display_name = re.sub('([a-z0-9])([A-Z])', r'\1-\2', display_name).lower()
    home = expanduser("~")
    print('home = ' + home)
    cred_file = home + "/.aws/credentials"
    config = configparser.RawConfigParser()
    config.read(cred_file)
    print("Display Name : " + display_name)
    rolesplit = role.split('/')
    profile_name = rolesplit[1]
#    profile_name = display_name.replace(" ","-")
#    section = 'saml' + str(count)
    section = display_name # profile_name #+ '_' + str(count)
    if not config.has_section(section):
        config.add_section(section)
    config.set(section, 'output', 'json')
    config.set(section, 'region', region)
    config.set(section, 'aws_access_key_id', cred['Credentials']['AccessKeyId'])
    config.set(section, 'aws_secret_access_key', cred['Credentials']['SecretAccessKey'])
    config.set(section, 'aws_session_token', cred['Credentials']['SessionToken'])
    with open(cred_file, 'w+') as credentials:
        config.write(credentials)
    print('\n\n')
    print('-' * 80)
    print('Your profile is created. It will expire at ' + str(cred['Credentials']['Expiration']))
    print('Use --profile ' + section + ' for the commands')
    print('Example - ')
    print('aws s3 ls --profile ' + section)
    print('-' * 80)
    with open('/tmp/profile', 'w') as profile:
        profile.write(section)
    

def assume_role_with_saml(role, principle, saml, count, display_name, region):
    stsclient = boto3.client('sts')
    try:
        cred = stsclient.assume_role_with_saml(RoleArn=role, PrincipalArn=principle, SAMLAssertion=saml)
    except ClientError as e:
        print("Access Denied. Please check.. " + str(e))
        logging.info(str(e))
        return False
    '''
    print(cred)
    print(cred['Credentials'])
    print(cred['Credentials']['SecretAccessKey'])
    print(cred['Credentials']['AccessKeyId'])
    print(cred['Credentials']['SessionToken'])
    '''
    write_cred(cred, count, display_name, region, role)
    return True
    
