# -*-coding: utf-8 -*-
#import xml.etree.ElementTree as ET
import xmltodict
import urllib2
from lxml import html
import json
import requests

class Fetcher:    
    # JSON : 0; XML : 1; Web : 2
    def __init__(self, url, dataType):
        self.url = url
        self.dataType = dataType
        if dataType == 0:
            self.getData()
        elif dataType == 1:
            self.getXMLData()
        elif dataType == 2:
            self.getWebInfo()
        else:
            print("Wrong DataType")
    
    def getData(self):
        # get the response from url ... 200 ok
        if not(self.respondOK()):
            return
        self.tree = html.fromstring(self.page.content)
    
    def selectNode(self, node):
        self.json = self.tree.xpath('//' + node + '/text()')
#        print(self.json)
    
    def getText(self):
        if self.dataType == 0:
            text = self.page.text
            self.data = json.loads(text.decode())
        
        return self.data
            
    
    def getXMLData(self):
        if not(self.respondOK()):
            return
        file = urllib2.urlopen(self.url)
        self.data = file.read()
        file.close()
        
        self.data = xmltodict.parse(self.data)
    
    def getWebInfo(self):
#        page = requests.get(self.url)
        #(We need to use page.content rather than page.text because html.fromstring implicitly expects bytes as input.)
        
#        tree = html.fromstring(page.content)
        '''
        tree now contains the whole HTML file in a nice tree structure which we can go over two different ways: XPath and CSSSelect. In this example, we will focus on the former.
        '''
#        return tree
        page = urllib2.urlopen(self.url).read()
        return page
    
    def respondOK(self):
        self.page = requests.get(self.url)
        
        if not(self.page.ok):
            print('GET DATA ERROR :' + self.page.status_code)
        
        return self.page.ok