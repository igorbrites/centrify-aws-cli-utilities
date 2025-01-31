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

from centrify.htmlparser import CentrifyHtmlParser
import logging

class HtmlResponse(object):
    '''
    Html Response from handle app click which consists of SAML
    '''
    def __init__(self, html_response):
        self.html_response = html_response
        self.saml = '';
        
    
    def get_saml(self):
        htmlparser = CentrifyHtmlParser()
        htmlparser.feed(self.html_response)
        saml = htmlparser.get_saml()
        htmlparser.clean()
        logging.info("------------ SAML ---------------")
        logging.info(saml)
        return saml
        
