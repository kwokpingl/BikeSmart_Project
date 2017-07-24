from Fetcher import Fetcher
import json

class JSONDecoder:
    
    def __init__(self, url):
        self.jsonURL    = url
    
    def fetchData(self):
        # FETCH DATA URL
        self.fetcher    = Fetcher(self.jsonURL)
        self.data       = self.fetcher.getText()
        self.isSuccess  = self.data['success']
        self.resultData = self.data['result']
        self.fields     = []
        self.records    = self.resultData['records']
        
        # get the id from the field
        for dic in self.resultData['fields']:
            self.fields.append(dic['id'])
        
        for record in self.records:
            
        

    # ValueError: too many values to unpack
    # If Dict has more than two keys*, they can't be unpacked into the tuple "k, m", hence the ValueError exception is raised.
#    for key, value in resultData.iteritems():
        