# -*- coding: utf-8 -*-
import mysql.connector
from mysql.connector import errorcode
import MySQLdb

from datetime import datetime
from dateutil.parser import parse
import time
#import pandas as pd

from Fetcher import Fetcher
from TBManager import TBManager

import json

class UBikeJSON_Decoder:
    
    def __init__(self, DB_NAME, USER, PWD, HOST):
        self.tbMgr = TBManager(DB_NAME, USER, PWD, HOST)
        self.urls = {}
        self.strptime = lambda date_string, format: datetime(*(time.strptime(date_string, format)[0:6]))
    
    def createTB(self, statement):
        tbMgr = self.tbMgr
        tbMgr.setTBNameArr(self.TBNames)
        tbMgr.createTBsWithStatement(statement)
    
    '''
    urls > KEYS, VALUES
    urls > TBName, URL
    '''
    def setupURLsDic(self, urls):
        self.urls = urls
        self.TBNames = []
#        for key, url in self.urls.iteritems():
        for key in self.urls.keys():
            self.TBNames.append(key)
    
    def fetchUBikeJSONData(self):
        # FETCH DATA URL
        tbMgr = self.tbMgr
        for key, url in self.urls.iteritems():
            
            fetcher   = Fetcher(url, 0)
            data      = fetcher.getText()
            isSuccess = data['success']
            resultData= data['result']
            fields    = []
            records   = resultData['records']
            
            # Insert into the Table
#            sno:    站點代號、
#
#            ar:     地址(中文)、
#            sna:    場站名稱(中文)、
#            sarea:  場站區域(中文)、
#
#            aren:   地址(英文)、
#            snaen:  場站名稱(英文)、
#            sareaen:場站區域(英文)、
#
#            tot:    場站總停車格、
#            sbi:    可借車位數、
#            bemp:   可還空位數、
#
#            mday:資料更新時間、
#            lat:緯度、
#            lng:經度、
#
#            act:場站是否暫停營運
            for record in records:
                stnNO      = int(record['sno'])
                
                adCn       = record['ar']
                snCn       = record['sna']
                saCn       = record['sarea']
                
                adEn       = record['aren']
                snEn       = record['snaen']
                saEn       = record['sareaen']
                
                tot        = int(record['tot'])
                bikes      = int(record['sbi'])
                spaces     = int(record['bemp'])
                
                uDate      = self.strptime(record['mday'], '%Y%m%d%H%M%S')
                lat        = float(record['lat'])
                lng        = float(record['lng'])
                act        = 1
                act        = int(record['act'])
                
                #Check if the stnNO exists
                
                checkData = ("SELECT * FROM " + key + \
                            " WHERE stnNO = '" + \
                             str(stnNO) + "'")
                if not tbMgr.checkData(checkData):
                    #As the whole query needs to be in a string format while execution of query so %s should be used.
                    addData = ("INSERT INTO " + key + \
                               "(stnNO, adCn, snCn, saCn," + \
                               " adEn, snEn, saEn," + \
                               " tot, bikes, spaces," + \
                               " uDate, lat, lng, act, type)" + \
                               " VALUES(%s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s, %s)")

                    dataToAdd = (stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, key)

                    #insert
                    tbMgr.insertData(addData, dataToAdd)
                else:
                    updateData = ("UPDATE " + key + \
                                  " SET adCn    = %s," + \
                                  " snCn    = %s," + \
                                  " saCn    = %s," + \
                                  " adEn    = %s," + \
                                  " snEn    = %s," + \
                                  " saEn    = %s," + \
                                  " tot     = %s," + \
                                  " bikes   = %s," + \
                                  " spaces  = %s," + \
                                  " uDate   = %s," + \
                                  " lat     = %s," + \
                                  " lng     = %s," + \
                                  " act     = %s," + \
                                  " type    = %s"  + \
                                  " WHERE stnNO = %s")
                    dataToUpdate = (adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, key, stnNO)
                    
                    tbMgr.updateData(updateData, dataToUpdate)
            print(key + " Updated")
                    
    def fetchTBikeJSONData(self): 
#       Id(編號)、
#       StationName(站名)、
#       Address(地址)、
#       Capacity(格位數)、
#       AvaliableBikeCount(可借車輛數)、
#       AvaliableSpaceCount(可停空位數)、
#       UpdateTime(更新時間)、
#       Latitude(緯度)、
#       Longitude(經度)

        adEns = {
            "保安轉運站":"No 519, Section 1, Wenxian Road, Rende District, Tainan City, 717",
            "十鼓文化村站":"No. 67, Section 2, Wenhua Road, Rende District, Tainan City, 717",
            "都會公園-文賢路站":"No. 1511, Section 1, Wenxian Road, Rende District, Tainan City, 717",
            "都會公園-文華路站":"Section 2, Wenhua Road, Rende District, Tainan City, 717",
            "都會公園-台1南停車場站":"No. 66, Section 2, Erren Road, Rende District, Tainan City, 717",
            "臺鐵南科站":"Xilaya Boulevard, Shanhua District, Tainan City, 741",
            "社區中心站":"Dashun 3rd Road, Xinshi District, Tainan City, 744",
            "南科管理局站":"Nanke 3rd Road, Xinshi District, Tainan City, 744",
            "樹谷生活科學館站":"Huoshui Road, Xinshi District, Tainan City, 744",
            "霞客湖站":"Nanke 7th Road, Shanhua District, Tainan City, 741",
            "民生轉運站":"Section 2, Minsheng Road, West Central District, Tainan City, 700",
            "赤嵌樓站":"No. 212, Section 2, Minzu Road, West Central District, Tainan City, 700",
            "延平郡王祠站":"Kaishan Road, West Central District, Tainan City, 700",
            "水交社文化園區站":"Nanmen Road, South District, Tainan City, 702",
            "體育園區站":"No. 42, Section 1, Jiankang Road, West Central District, Tainan City, 700",
            "美術館站":"No. 258, Section 1, Fuqian Road, West Central District, Tainan City, 700",
            "臺南市政府站":"No. 614, Section 2, Fuqian Road, Anping District, Tainan City, 708",
            "衛生局站":"Section 1, Linsen Road, East District, Tainan City, 701",
            "和順公園站":"No. 406, Gongyuan South Road, North District, Tainan City, 704",
            "安億停車場站":"708, Tainan City, Anping District, 708",
            "健康西門路站":"No. 20, Section 2, Jiankang Road, South District, Tainan City, 702",
            "開元轉運站":"No. 220-270, Nanheng Road, North District, Tainan City, 704",
            "嘉南藥理大學站":"No. 20, Lane 56, Section 1, Bao'an Road, Rende District, Tainan City, 717",
            "南區公所站":"No. 233, Section 2, Zhonghua South Road, South District, Tainan City, 702",
            "萬年公園站":"Lane 61, Wanli Road, South District, Tainan City, 702",
            "臺南火車站前站":"Chenggong Road, North District, Tainan City, 704",
            "台南公園站":"Gongyuan Road & Gongyuan South Road, North District, Tainan City, 704",
            "成大會館站":"Shengli Road & Daxue Rd, East District, Tainan City, 701",
            "史博館站":"No. 250, Section 1, Zhanghe Road, Annan District, Tainan City, 709",
            "億載金城站":"No. 88, Guangzhou Road, Anping District, Tainan City, 708",
            "永華文平站":"No. 433, Section 2, Yonghua Road, Anping District, Tainan City, 708",
            "巴克禮公園站":"Section 3, Zhonghua East Road, East District, Tainan City, 701",
            "東寧運動公園站":"No. 214, Dongning Road, East District, Tainan City, 701",
            "家庭教育中心站":"No. 127, Gongyuan Road, West Central District, Tainan City, 700",
            "花園夜市站":"Section 3, Hai'an Road, North District, Tainan City, 704",
            "台糖嘉年華站":"No. 7, Section 3, Datong Road, Rende District, Tainan City, 717",
            "台積電南科站":"Jing Dian S3 Factory ), Shanhua District, Tainan City, 741",
            "水萍塭公園站":"No. 1-17, Xialin Road, South District, Tainan City, 702",
            "林默娘公園站":"No. 142, Anyi Road, Anping District, Tainan City, 708",
            "小東公園站":"No. 94, Xiaodong Road, East District, Tainan City, 701",
            "大興公園站":"No. 986, Wenxian Road, North District, Tainan City, 704",
            "海安民族站":"No. 268, Section 2, Hai'an Road, West Central District, Tainan City, 700",
            "臺灣文學館站":"No. 8-3, You'ai Street, West Central District, Tainan City, 700",
            "成大醫院站":"No. 35, Xiaodong Road, North District, Tainan City, 704",
            "臺南火車站後站":"Chenggong Road, North District, Tainan City, 704",
            "青年公園站":"No. 260, Yule Street, East District, Tainan City, 701",
            "虎尾寮市場站":"Yuping Road, East District, Tainan City, 701",
            "東寧裕農站":"No. 544, Dongning Road, East District, Tainan City, 701",
            "鹽埕圖書館站":"No. 51, Xinhe East Road, South District, Tainan City, 702",
            "和意路站":"No. 58, Heyi Road, West Central District, Tainan City, 700",
            "安平區公所站":"No. 622, Pingtong Road, Anping District, Tainan City, 708",
            "臺南市議會站":"No. 16, Section 2, Zhonghua West Road, West Central District, Tainan City, 700"
        }
        
        
        
        tbMgr = self.tbMgr
        for key, url in self.urls.iteritems():
            fetcher = Fetcher(url, 0)
            records = fetcher.getText()
            
            for record in records:
                stnNO   = record['Id']
                adCn    = record['Address']
                snCn    = record['StationName']
                saCn    = ""
                
                adEn    = ""
                if snCn in adEns.keys():
                    #When using Chinese characters as Key, 
                    #must first Encode with UTF-8
                    #otherwise, u'/xxxx won't work
                    #must be /x99/x00
                    
                    #KeyError: u'\u4fdd\u5b89\u8f49\u904b\u7ad9'
                    adEn = adEns[snCn.encode('utf-8')]
                else:
                    adEn = "Unknown"
                snEn    = "Bike Sharing Station"
                saEn    = ""
                
                tot     = record['Capacity']
                bikes   = record['AvaliableBikeCount']
                spaces  = record['AvaliableSpaceCount']
                # use %S.%f if there is decimal
                try:
                    uDate   = self.strptime(record['UpdateTime'], "%Y-%m-%dT%H:%M:%S.%f")
                except ValueError:
                    uDate   = self.strptime(record['UpdateTime'], "%Y-%m-%dT%H:%M:%S")
                lat     = record['Latitude']
                lng     = record['Longitude']
                act     = 1
                
                #Check if the stnNO exists
                
                checkData = ("SELECT * FROM " + key + \
                            " WHERE stnNO = '" + \
                             str(stnNO) + "'")
                if not tbMgr.checkData(checkData):
                    #As the whole query needs to be in a string format while execution of query so %s should be used.
                    addData = ("INSERT INTO " + key + \
                               "(stnNO, adCn, snCn, saCn," + \
                               " adEn, snEn, saEn," + \
                               " tot, bikes, spaces," + \
                               " uDate, lat, lng, act," + \
                               " type)" + \
                               " VALUES(%s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s, %s)")

                    dataToAdd = (stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, key)

                    #insert
                    tbMgr.insertData(addData, dataToAdd)
                else:
                    updateData = ("UPDATE " + key + \
                                  " SET adCn    = %s," + \
                                  " snCn    = %s," + \
                                  " saCn    = %s," + \
                                  " adEn    = %s," + \
                                  " snEn    = %s," + \
                                  " saEn    = %s," + \
                                  " tot     = %s," + \
                                  " bikes   = %s," + \
                                  " spaces  = %s," + \
                                  " uDate   = %s," + \
                                  " lat     = %s," + \
                                  " lng     = %s," + \
                                  " act     = %s," + \
                                  " type    = %s"  + \
                                  " WHERE stnNO = %s")
                    dataToUpdate = (adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, key,stnNO)
                    
                    tbMgr.updateData(updateData, dataToUpdate)
            print(key + " Updated")
        
        
    # ValueError: too many values to unpack
    # If Dict has more than two keys*, they can't be unpacked into the tuple "k, m", hence the ValueError exception is raised.
#    for key, value in resultData.iteritems():

    
    # Function that Extract XML From CBike
    