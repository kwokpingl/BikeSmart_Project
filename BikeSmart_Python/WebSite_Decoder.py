# -*- coding: utf-8 -*-
import mysql.connector
from mysql.connector import errorcode
import MySQLdb

from datetime import datetime
from dateutil.parser import parse
import time

import re
import json
import urllib

from Fetcher import Fetcher
from TBManager import TBManager
from bs4 import BeautifulSoup as BS

class WebSite_Decoder:
    
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
    
    def fetchWebData(self):
        # FETCH DATA URL
        tbMgr = self.tbMgr
        for key, urlArray in self.urls.iteritems():
            
            if (key == "IBike_HCC" 
                or key == "UBike_HC" 
                or key == "UBike_CH"):
                
                fetcher     = Fetcher(urlArray[0], 2)
                page        = fetcher.getWebInfo()
                soup        = BS(page, "lxml")
                
                records = self.extractUBikeInfo(soup)
                records = json.loads(records)
                self.recordUBikeInfo(records, key, False)
                
                fetcher     = Fetcher(urlArray[1], 2)
                page        = fetcher.getWebInfo()
                soup        = BS(page, 'lxml')
                
                records = self.extractUBikeInfo(soup)
                records = json.loads(records)
                self.recordUBikeInfo(records, key, True)
            
            if key == 'EBike_CY':
                self.setupAdsnens(key)
                fetcher     = Fetcher(urlArray[0], 2)
                page        = fetcher.getWebInfo()
                soup        = BS(page, 'html.parser')
                records     = self.extractEBikeInfo(soup)
                self.recordEBikeInfo(records, key)
            
            if key == 'KBike_KM':
                self.setupAdsnens(key)
                fetcher     = Fetcher(urlArray[0], 2)
                page        = fetcher.getWebInfo()
                soup        = BS(page, 'html.parser')
                records     = self.extractKBikeInfo(soup)
                self.recordKBikeInfo(records, key)
                
                
                
    # Setup the Dictionaries for Translations
    def setupAdsnens(self, key):
        self.adsnens = {}
        
        if key == 'EBike_CY':
            self.eBikeData  = {
                "嘉義醫院站":{
                    "stnNO" : 1,
                    "adCn"  : "嘉義市西區北港路312號",
                    "snCn"  : "嘉義醫院站",
                    "saCn"  : "西區",
                    
                    "adEn"  : "No.312, Beigang Rd., West Dist., Chiayi City, 600",
                    "snEn"  : "Chia-Yi Hospital",
                    "saEn"  : "West Dist.",
                    
                    "lat"   : "23.48043",
                    "lng"   : "120.4297",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "體育館站":{
                    "stnNO" : 2,
                    "adCn"  : "嘉義市東區彌陀路上垂楊路日新路之間",
                    "snCn"  : "體育館站",
                    "saCn"  : "東區",
                    
                    "adEn"  : "Intersection amoung Mituo Road, Chuiyang Road & Rixin Road, East District, Chiayi City, 600",
                    "snEn"  : "Chiayi City Gymnasium",
                    "saEn"  : "East Dist.",
                    
                    "lat"   : "23.47388",
                    "lng"   : "120.4623",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "興業吳鳳站":{
                    "stnNO" : 3,
                    "adCn"  : "嘉義市東區興業東路近吳鳳南路口",
                    "snCn"  : "興業吳鳳站",
                    "saCn"  : "東區",
                    
                    "adEn"  : "Xingye E Road & Wufeng S. Road, East District, Chiayi City, 600",
                    "snEn"  : "Xingye E. Road & Wufeng S. Road",
                    "saEn"  : "East Dist.",
                    
                    "lat"   : "23.46931",
                    "lng"   : "120.45475",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "文化公園站":{
                    "stnNO" : 4,
                    "adCn"  : "嘉義市東區文化路口與康樂街口",
                    "snCn"  : "文化公園站",
                    "saCn"  : "東區",
                    
                    "adEn"  : "Wenhua Road & Kangle Street, West District, Chiayi City, 600",
                    "snEn"  : "Wenhua Park",
                    "saEn"  : "East Dist.",
                    
                    "lat"   : "23.47509",
                    "lng"   : "120.45019",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "嘉義公園站":{
                    "stnNO" : 5,
                    "adCn"  : "嘉義市東區中山路10號與啟明路口",
                    "snCn"  : "嘉義公園站",
                    "saCn"  : "東區",
                    
                    "adEn"  : "No. 10, Zhongshan Road & Qiming Road, East District, Chiayi City, 600",
                    "snEn"  : "Chiayi Park",
                    "saEn"  : "East Dist.",
                    
                    "lat"   : "23.48272",
                    "lng"   : "120.46294",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "噴水站":{
                    "stnNO" : 6,
                    "adCn"  : "嘉義市東區中山路287號前",
                    "snCn"  : "噴水站",
                    "saCn"  : "東區",
                    
                    "adEn"  : "No. 287, Zhongshan Road, East District, Chiayi City, 600",
                    "snEn"  : "Fountain",
                    "saEn"  : "East Dist.",
                    
                    "lat"   : "23.48005",
                    "lng"   : "120.45017",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "檜意站":{
                    "stnNO" : 7,
                    "adCn"  : "嘉義市東區忠孝路與共和路199巷路口",
                    "snCn"  : "檜意站",
                    "saCn"  : "東區",
                    
                    "adEn"  : "Zhongxiao Rd. & Lane 199, Gonghe Rd., East Dist., Chiayi City, 600",
                    "snEn"  : "Fountain",
                    "saEn"  : "East Dist.",
                    
                    "lat"   : "23.48603",
                    "lng"   : "120.4538",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "三越遠東站":{
                    "stnNO" : 8,
                    "adCn"  : "嘉義市西區垂楊路廣寧路口",
                    "snCn"  : "三越遠東站",
                    "saCn"  : "西區",
                    
                    "adEn"  : "Chuiyang Road & Guangning Street, West District, Chiayi City, 600",
                    "snEn"  : "SOGO & Far East",
                    "saEn"  : "West Dist.",
                    
                    "lat"   : "23.47294",
                    "lng"   : "120.44141",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "興業新民站":{
                    "stnNO" : 9,
                    "adCn"  : "嘉義市西區興業西路與新民路路口",
                    "snCn"  : "興業新民站",
                    "saCn"  : "西區",
                    
                    "adEn"  : "Xingye West Road & Xinmin Road, West District, Chiayi City, 600",
                    "snEn"  : "SOGO & Far East",
                    "saEn"  : "West Dist.",
                    
                    "lat"   : "23.46794",
                    "lng"   : "120.44033",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "家樂福站":{
                    "stnNO" : 10,
                    "adCn"  : "嘉義市西區博愛路二段興業西路口",
                    "snCn"  : "家樂福站",
                    "saCn"  : "西區",
                    
                    "adEn"  : "Section 2, Bo'ai Road & Xingye West Road, West District, Chiayi City, 600",
                    "snEn"  : "Carrefour",
                    "saEn"  : "West Dist.",
                    
                    "lat"   : "23.47124",
                    "lng"   : "120.43085",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "嘉義火車站":{
                    "stnNO" : 11,
                    "adCn"  : "嘉義市西區中山路528號(嘉義火車站剪票口附近汽車停等區)",
                    "snCn"  : "嘉義火車站",
                    "saCn"  : "西區",
                    
                    
                    "adEn"  : "No. 528, Zhongshan Road, West District, Chiayi City, 600 (Chiayi Train Station Boarding Entrance near Car Waiting Zone)",
                    "snEn"  : "Chiayi Train Station",
                    "saEn"  : "West Dist.",
                    
                    
                    "lat"   : "23.47896",
                    "lng"   : "120.44108",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                }
            }
            

        if key == 'KBike_KM':
            
            self.kBikeData = {
                "A1金城車站A": {
                    "stnNO" : 1,
                    "adCn"  : "民生路10號",
                    "snCn"  : "A1金城車站A",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "No. 10, Minshen Road, County, Jincheng Township, Kinmen County, 893",
                    "snEn"  : "A1 Kim Cheng Station A",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.433994",
                    "lng"   : "118.319938",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A1金城車站B":{
                    "stnNO" : 2,
                    "adCn"  : "民生路10號",
                    "snCn"  : "A1金城車站B",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "No. 10, Minshen Road, County, Jincheng Township, Kinmen County, 893",
                    "snEn"  : "A1 Kim Cheng Station B",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.433994",
                    "lng"   : "118.319938",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A2金城民防坑道出口":{
                    "stnNO" : 3,
                    "adCn"  : "光前路與珠浦西路",
                    "snCn"  : "A2金城民防坑道出口",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "Gongcian Road & Zhupu West Road, Jinning Township, Kinmen County, 892",
                    "snEn"  : "A2 Kin Cheng Civil Defense Tunnel Exit",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.437065",
                    "lng"   : "118.312256",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A3縣立體育場A":{
                    "stnNO" : 4,
                    "adCn"  : "民族路與西海路三段",
                    "snCn"  : "A3縣立體育場A",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "Minzhu Road & Section 3, SiHi Road, Jincheng Township, Kinmen County, 893",
                    "snEn"  : "A3 Kinmen County Stadium",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.430182",
                    "lng"   : "118.315312",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A3縣立體育場B":{
                    "stnNO" : 5,
                    "adCn"  : "民族路與西海路三段",
                    "snCn"  : "A3縣立體育場B",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "Minzhu Road & Section 3, SiHi Road, Jincheng Township, Kinmen County, 893",
                    "snEn"  : "A3 Kinmen County Stadium",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.430182",
                    "lng"   : "118.315312",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A4莒光樓":{
                    "stnNO" : 6,
                    "adCn"  : "賢城路1號",
                    "snCn"  : "A4莒光樓",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "No. 1, Xiancheng Road, Jincheng Township, Kinmen County, 893",
                    "snEn"  : "A4 Jyuguang Tower",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.425083",
                    "lng"   : "118.318137",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A5水頭碼頭":{
                    "stnNO" : 7,
                    "adCn"  : "西海路一段",
                    "snCn"  : "A5水頭碼頭",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "Between No. 5 & No. 11, Sihi Road, Jincheng Township, Kinmen County, 893",
                    "snEn"  : "A5 Shuitou Pier",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.414469",
                    "lng"   : "118.286348",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A6水頭聚落":{
                    "stnNO" : 8,
                    "adCn"  : "前水頭 (水頭客棧附近)",
                    "snCn"  : "A6水頭聚落",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "Chenshuitou, Jincheng Township, Kinmen County, 893 (around Shui Tou Inn)",
                    "snEn"  : "A6 Shuitou (Huang clan)",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.411498",
                    "lng"   : "118.296849",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A7翟山坑道":{
                    "stnNO" : 9,
                    "adCn"  : "往翟山坑道的道路上",
                    "snCn"  : "A7翟山坑道",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "Jincheng Township, Kinmen County, 893 (on the path to Zhaishan Tunnel)",
                    "snEn"  : "A7 Zhaishan Tunnel",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.390557",
                    "lng"   : "118.320793",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "A8珠山聚落":{
                    "stnNO" : 10,
                    "adCn"  : "珠山 (薛永南兄弟大樓旁)",
                    "snCn"  : "A8珠山聚落",
                    "saCn"  : "金城鎮",
                    
                    
                    "adEn"  : "Jusan, Jincheng Township, Kinmen County, 893 (beside Xue Yong Nan Brothers' Building)",
                    "snEn"  : "A8 Jusan Clan",
                    "saEn"  : "Jincheng Township",
                    
                    
                    "lat"   : "24.402838",
                    "lng"   : "118.321120",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "B1金門大學A":{
                    "stnNO" : 11,
                    "adCn"  : "金門大學與榕園之間的道路",
                    "snCn"  : "B1金門大學A",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "The road between National Quemoy/Kinmen University and Banyan Park (Ron-Yuan)",
                    "snEn"  : "B1 Kinmen University A",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.448731",
                    "lng"   : "118.321653",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "B1金門大學B":{
                    "stnNO" : 12,
                    "adCn"  : "金門大學與榕園之間的道路",
                    "snCn"  : "B1金門大學B",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "The road between National Quemoy/Kinmen University and Banyan Park (Ron-Yuan)",
                    "snEn"  : "B1 Kinmen University B",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.448731",
                    "lng"   : "118.321653",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "B2慈湖三角堡":{
                    "stnNO" : 13,
                    "adCn"  : "三角堡",
                    "snCn"  : "B2慈湖三角堡",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "Section 3, Cihu Road, Jinning Township, Kinmen County, 892 (Triangle Fortress)",
                    "snEn"  : "B2 Cihu Triangle Fortress",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.465424",
                    "lng"   : "118.297757",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "B3和平紀念公園":{
                    "stnNO" : 14,
                    "adCn"  : "頂林路與環島西路二段 (臨金門和平紀念園)",
                    "snCn"  : "B3和平紀念公園",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "Dinglin Road & Section 2, Huandao West Road (Close to Kinmen Heping Memorial Park)",
                    "snEn"  : "B3 Heping Memorial Park",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.475537",
                    "lng"   : "118.316468",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "B4中山紀念林":{
                    "stnNO" : 15,
                    "adCn"  : "中山林遊客中心對面",
                    "snCn"  : "B4中山紀念林",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "No. 460, Section 2, Boyu Road, Jinning Township, Kinmen County, 892 (Across from Zhongshanlin Visitor Center)",
                    "snEn"  : "B4 Zhongshanlin Memorial Forest",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.443960",
                    "lng"   : "118.353098",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "B5后湖濱海公園":{
                    "stnNO" : 16,
                    "adCn"  : "后湖濱海公園(東湖路上)",
                    "snCn"  : "B5后湖濱海公園",
                    "saCn"  : "金寧鎮",
                    
                    
                    "adEn"  : "HouHu Coast Park (on DonHu Road)",
                    "snEn"  : "B5 HouHu Coast Park",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.417034",
                    "lng"   : "118.344376",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "C1森林遊樂區":{
                    "stnNO" : 17,
                    "adCn"  : "金門森林遊樂區第一停車場旁",
                    "snCn"  : "C1森林遊樂區",
                    "saCn"  : "金沙鎮",
                    
                    
                    "adEn"  : "Jinsha Township, Kinmen County, 890 (Beside Forest Recreation Parking Lot - The first Kinmen Parking Lot)",
                    "snEn"  : "C1 Forest Recreation Area",
                    "saEn"  : "Jinsha Township",
                    
                    
                    "lat"   : "24.459053",
                    "lng"   : "118.442588",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "C2陽翟聚落":{
                    "stnNO" : 18,
                    "adCn"  : "環道西路一段與陽翟",
                    "snCn"  : "C2陽翟聚落",
                    "saCn"  : "金沙鎮",
                    
                    
                    "adEn"  : "Section 2, Huandao West Road & Yangzhai, Jinsha Township, Kinmen County, 890",
                    "snEn"  : "C2 Yang Zhai Clan",
                    "saEn"  : "Jinsha Township",
                    
                    
                    "lat"   : "24.478418",
                    "lng"   : "118.426839",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "C3沙美車站":{
                    "stnNO" : 19,
                    "adCn"  : "復興路與環島東路一段",
                    "snCn"  : "C3沙美車站",
                    "saCn"  : "金沙鎮",
                    
                    
                    "adEn"  : "Section 1, Huandao East Road & FuXing Road, Jinsha Township, Kinmen County, 890",
                    "snEn"  : "C3 Shamei Station",
                    "saEn"  : "Jinsha Township",
                    
                    
                    "lat"   : "24.488795",
                    "lng"   : "118.413285",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "C4文化園區":{
                    "stnNO" : 20,
                    "adCn"  : "田墩",
                    "snCn"  : "C4文化園區",
                    "saCn"  : "金沙鎮",
                    
                    
                    "adEn"  : "Tian Tun, ",
                    "snEn"  : "C4 Cultural Park",
                    "saEn"  : "Jinsha Township",
                    
                    
                    "lat"   : "24.497403",
                    "lng"   : "118.402782",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "C5獅山砲陣地":{
                    "stnNO" : 21,
                    "adCn"  : "陽沙路",
                    "snCn"  : "C5獅山砲陣地",
                    "saCn"  : "金沙鎮",
                    
                    
                    "adEn"  : "Yangsha Road ,Jinsha Township, Kinmen County, 890",
                    "snEn"  : "C5 Shishan (Mt. Lion) Howitzer Front",
                    "saEn"  : "Jinsha Township",
                    
                    
                    "lat"   : "24.504082",
                    "lng"   : "118.437352",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "D1尚義機場":{
                    "stnNO" : 22,
                    "adCn"  : "金門尚義機場旅遊服務中心右邊",
                    "snCn"  : "D1尚義機場",
                    "saCn"  : "金湖鎮",
                    
                    
                    "adEn"  : "On the Right of Kinmen Airport Tourist Information Center",
                    "snEn"  : "D1 Shang Yi / Kinmen Airport",
                    "saEn"  : "Jinhu Township",
                    
                    
                    "lat"   : "24.437375",
                    "lng"   : "118.369578",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "D2柳營一營區":{
                    "stnNO" : 23,
                    "adCn"  : "環島南路三段 (王氏家廟後方)",
                    "snCn"  : "D2柳營一營區",
                    "saCn"  : "金湖鎮",
                    
                    
                    "adEn"  : "Section 3, Huandao South Road, Jinhu Township, Kinmen County, 891 (Behind The Wong Temple)",
                    "snEn"  : "D2 Luying 1st Campus",
                    "saEn"  : "Jinhu Township",
                    
                    
                    "lat"   : "24.438289",
                    "lng"   : "118.379751",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "D3瓊林坑道":{
                    "stnNO" : 24,
                    "adCn"  : "怡穀堂旁",
                    "snCn"  : "D3瓊林坑道",
                    "saCn"  : "金湖鎮",
                    
                    
                    "adEn"  : "Cyongyi Road, Jinhu Township, Kinmen County, 891 (Beside Yi Gu Tang)",
                    "snEn"  : "D3 Cyonglin Tunnels",
                    "saEn"  : "Jinhu Township",
                    
                    
                    "lat"   : "24.454866",
                    "lng"   : "118.372630",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "D4山外車站":{
                    "stnNO" : 25,
                    "adCn"  : "復興西路與黃海路",
                    "snCn"  : "D4山外車站",
                    "saCn"  : "金湖鎮",
                    
                    
                    "adEn"  : "Fuxing West Road & Huanghai Road, Jinhu Township, Kinmen County, 891",
                    "snEn"  : "D4 Shanwai Bus Station",
                    "saEn"  : "Jinhu Township",
                    
                    
                    "lat"   : "24.442308",
                    "lng"   : "118.414262",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "D5畜試所":{
                    "stnNO" : 26,
                    "adCn"  : "惠民富康農莊17號 (畜產試驗所旁)",
                    "snCn"  : "D5畜試所",
                    "saCn"  : "金湖鎮",
                    
                    
                    "adEn"  : "No. 17, Huiminfukang Farm, Kinmen County, Jinhu Township, 891",
                    "snEn"  : "D5 Animal Products Research Institute",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.433307",
                    "lng"   : "118.438134",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "D6中正公園":{
                    "stnNO" : 27,
                    "adCn"  : "中正公園 (明園民宿對面)",
                    "snCn"  : "D6中正公園",
                    "saCn"  : "金湖鎮",
                    
                    
                    "adEn"  : "Section 3, Taihu Road, Jinhu Township, Kinmen County, 891 (Across from Ming Yuan Bed And Breakfast)",
                    "snEn"  : "D6 Zhong Zheng Park",
                    "saEn"  : "Jinning Township",
                    
                    
                    "lat"   : "24.436906",
                    "lng"   : "118.426258",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "E1羅厝漁港":{
                    "stnNO" : 28,
                    "adCn"  : "南環道 (臨 列嶼羅厝西湖古廟-天上聖母)",
                    "snCn"  : "E1羅厝漁港",
                    "saCn"  : "烈嶼鄉",
                    
                    
                    "adEn"  : "Nan Huan Road, Lieyu Township, Kinmen County, 894 (Near Xi Hu Old Temple)",
                    "snEn"  : "E1 Luocuo fishing Harbor",
                    "saEn"  : "Lieyu Township",
                    
                    
                    "lat"   : "24.424904",
                    "lng"   : "118.259380",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                },
                
                "E2烈嶼鄉文化館":{
                    "stnNO" : 29,
                    "adCn"  : "西路1號 (忠義廟對面)",
                    "snCn"  : "E2烈嶼鄉文化館",
                    "saCn"  : "烈嶼鄉",
                    
                    
                    "adEn"  : "No. 1, Xi Road, Lieyu Township, Kinmen County, 894 (Across from Zhong Yi Temple)",
                    "snEn"  : "E2 Lieyu Township Cultural Museum",
                    "saEn"  : "Lieyu Township",
                    
                    
                    "lat"   : "24.431334",
                    "lng"   : "118.244748",
                    
                    
                    "pic1"  : "",
                    "pic2"  : ""
                }
            }
    
    # ============== UBIKE =========================
    
    # Get Info from UBike Official Site
    def extractUBikeInfo(self, soup):
        js = soup.find_all("script")
        # Get the last <script></script>
        script = js[len(js) - 1]
        # Get whatever is between <script> and </script>
        # then convert it into string to do Regex search
        script = str(script.contents)
        # Setup the splitting reference
        p = re.compile(r'arealist=')
        # Split the string
        substring = p.split(script)
        # Grab the string of interest (data)
        substring = substring[1]
        # Remove unwanted strings
        p = re.compile("\\\\|\'|\;")
        substring = p.sub("", substring)
        # Decode Percent-Encoding 
        # Now it becomes a dictionary
        return urllib.unquote(substring)
    
    # Record the UBike Data and save in DB
    def recordUBikeInfo(self, records, key, isEn):
        tbMgr = self.tbMgr
        
        for stn, record in records.iteritems():
            
            stnNO   = int(record['sno'])
            adCn    = ""
            snCn    = ""
            saCn    = ""
            
            adEn    = ""
            snEn    = ""
            saEn    = ""

            tot     = '0'
            bikes   = '0'
            spaces  = '0'

            uDate   = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            lat     = '0.00000'
            lng     = '0.00000'
            act     = 0
            
            pic1    = ""
            pic2    = ""


            if isEn:
                adEn        = record['ar'].replace('+', " ")
                snEn        = record['sna'].replace('+', " ")
                saEn        = record['sarea'].replace('+', " ")
            else:  
                adCn        = record['ar']
                snCn        = record['sna']
                saCn        = record['sarea']
                adEn        = ""
                snEn        = ""
                saEn        = ""

                tot        = int(record['tot'])
                bikes      = int(record['sbi'])
                spaces     = int(record['bemp'])

                uDate      = self.strptime(record['mday'], '%Y%m%d%H%M%S')
                lat        = float(record['lat'])
                lng        = float(record['lng'])
                act        = 1
                

            self.writeDB(tbMgr, stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key, isEn)
                
        print(key + " Updated")
    
    #================ UBIKE END ======================
    
    #================= EBIKE =========================
    
    def extractEBikeInfo(self, soup):
        trs = soup.find_all("tr", {"id" : 'tr'})
        records = {}
        for tr in trs:
            tds = tr.find_all("td", {"class": 'css_td'})
            if len(tds) > 0:
                dic = {}
                key = tds[0].get_text()
                if key in self.eBikeData.keys():
                    dic     = self.eBikeData[key.encode('utf-8')]
                    snCn    = dic["snCn"]
                    
                    bikes   = tds[1].get_text()
                    spaces  = tds[2].get_text()
                    
                    tot     = str(int(bikes) + int(spaces))
                    act     = 0
                    
                    if tds[3].get_text() == "正常營運":
                        act     = 1
                    dic["act"]    = act
                    dic["bikes"]  = bikes
                    dic["spaces"] = spaces
                    dic["tot"]  = tot
                    
                    records[snCn] = dic
                    
        return records
    
    
    
    def recordEBikeInfo(self, records, key):
        tbMgr = self.tbMgr
        
        for stn, record in records.iteritems():
            
            stnNO   = int(record['stnNO'])
            adCn    = record["adCn"]
            snCn    = record["snCn"]
            saCn    = record["saCn"]
            
            adEn    = record["adEn"]
            snEn    = record["snEn"]
            saEn    = record["saEn"]

            tot     = int(record["tot"])
            bikes   = int(record["bikes"])
            spaces  = int(record["spaces"])

            uDate   = time.strftime("%Y%m%d%H%M%S")
            lat     = float(record['lat'])
            lng     = float(record['lng'])
            act     = record["act"]
            
            pic1    = record["pic1"]
            pic2    = record["pic2"]
            
            self.writeDB(tbMgr, stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key, False)
                
        print(key + " Updated")
    
    #================= EBIKE END =========================
    
    #================= KBIKE    ==========================
    
    def extractKBikeInfo(self, soup):
        divCs   = soup.find_all("div", {"class":"ui-grid-c"})
        
#        </div>
#            更新時間: 2017-08-06 11:57:09</div>
#                        </body>

#        extracter = re.compile()

        dateStr = soup.find("div", {"id":"pageone"}).contents[-1]
        
        date    = dateStr.replace("更新時間: ", "")
        
        records = {}
        
        for divC in divCs:
            
            blockAs = divC.find("div", {"class":"ui-block-a"})
            blockBs = divC.find("div", {"class":"ui-block-b"})
            blockCs = divC.find("div", {"class":"ui-block-c"})
            blockDs = divC.find("div", {"class":"ui-block-d"})
            
            for blockA, blockB, blockC, blockD in zip(blockAs, blockBs, blockCs, blockDs):
                if blockA.find("a") == -1 or blockA.find("a") == None:
                    continue
                else:
                    # FETCH all the valid Contents
                    # snCn is used as key
                    key     = blockA.find("a").contents[0]
                    bikes   = int(blockB.contents[0])
                    spaces  = int(blockC.contents[0])
                    tot     = bikes + spaces
                    img     = blockD.img.get("src")[0]
                    act     = 1
                    if "gg" in img:
                        act = 0
                    
                    if key in self.kBikeData.keys():
                        dic     = self.kBikeData[key.encode('utf-8')]
                        
                        dic["bikes"]    = bikes
                        dic["spaces"]   = spaces
                        dic["tot"]      = tot
                        dic["uDate"]    = date
                        dic["act"]      = act
                        records[key]    = dic
        return records
    
    
    def recordKBikeInfo(self, records, key):
        tbMgr = self.tbMgr
        
        for stn, record in records.iteritems():
            
            stnNO   = int(record['stnNO'])
            adCn    = record["adCn"]
            snCn    = record["snCn"]
            saCn    = record["saCn"]
            
            adEn    = record["adEn"]
            snEn    = record["snEn"]
            saEn    = record["saEn"]

            tot     = int(record["tot"])
            bikes   = int(record["bikes"])
            spaces  = int(record["spaces"])

            uDate   = time.strftime("%Y-%m-%d %H:%M:%S")
            lat     = float(record['lat'])
            lng     = float(record['lng'])
            act     = record["act"]
            
            pic1    = record["pic1"]
            pic2    = record["pic2"]
            
            self.writeDB(tbMgr, stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key, False)
                
        print(key + " Updated")
    
    #================= KBIKE END =========================
    
    #================= FUNCTIONS =========================
    def strToArr(self, strings, sep):
        array = []
        for string in strings:
            array.append(re.split(sep, string))
        return array
    
    # input all data and Write into DB
    def writeDB(self, tbMgr, stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key, isEn):
        #Check if the stnNO exists

            checkData = ("SELECT * FROM " + key + \
                        " WHERE stnNO = '" + \
                         str(stnNO) + "'")
            
            if isEn:
                if not tbMgr.checkData(checkData):
                    #As the whole query needs to be in a string format while execution of query so %s should be used.
                    addData = ("INSERT INTO " + key + \
                               "(stnNO, adEn, snEn, saEn)" + \
                               " VALUES(%s, %s, %s, %s)")

                    dataToAdd = (stnNO, adEn, snEn, saEn)

                    #insert
                    tbMgr.insertData(addData, dataToAdd)
                else:
                    updateData = ("UPDATE " + key + \
                                  " SET adEn    = %s," + \
                                  " snEn    = %s," + \
                                  " saEn    = %s" + \
                                  " WHERE stnNO = %s")
                    dataToUpdate = (adEn, snEn, saEn, stnNO)

                    tbMgr.updateData(updateData, dataToUpdate)
            else:
                if not tbMgr.checkData(checkData):
                    #As the whole query needs to be in a string format while execution of query so %s should be used.
                    addData = ("INSERT INTO " + key + \
                               "(stnNO, adCn, snCn, saCn," + \
                               " adEn, snEn, saEn," + \
                               " tot, bikes, spaces," + \
                               " uDate, lat, lng, act," + \
                               " pic1, pic2, type)" + \
                               " VALUES(%s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s," + \
                               " %s, %s, %s)")

                    dataToAdd = (stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key)

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
                                  " pic1    = %s," + \
                                  " pic2    = %s," + \
                                  " type    = %s"  + \
                                  " WHERE stnNO = %s")
                    dataToUpdate = (adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key, stnNO)

                    tbMgr.updateData(updateData, dataToUpdate)
    
    
    def checkType(self, var):
        if var is list:
            print("LIST")
        elif var is dict:
            print("DICT")
        elif var is str:
            print("STR")
        elif var is int:
            print("INT")
    
    def ifContains(self, string, word):
        if word in string:
            print("True")
        else:
            print("False")
    # ValueError: too many values to unpack
    # If Dict has more than two keys*, they can't be unpacked into the tuple "k, m", hence the ValueError exception is raised.
#    for key, value in resultData.iteritems():

    
    # Function that Extract XML From CBike
    