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

import logging

class Application(object):

    def __init__(self, awsenv, centrifyenv, appkey, role):
        self.awsenv = awsenv
        self.centrifyenv = centrifyenv
        self.appkey = appkey
        self.role = role
        
    def get_aws_env(self):
        return self.awsenv
    
    def get_centrify_env(self):
        return self.centrifyenv
    
    def get_appkey(self):
        return self.appkey
    
    def get_role(self):
        return self.role
    
    def log_application(self):
        logging.info('--------- Application -----------')
        logging.info(self.awsenv)
        logging.info(self.centrifyenv)
        logging.info(self.appkey)
        logging.info(self.role)
