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
        for key, url in self.urls.iteritems():
            
            fetcher   = Fetcher(url, 2)
            page      = fetcher.getWebInfo()
            soup = BS(page, "lxml")
            
            if key == "IBike_HCC":
                records = self.extractUBikeInfo(soup)
                records = json.loads(records)
                self.recordUBikeInfo(records, key)
    
    def setupAdsnens(self, key):
        self.adsnens = {}
        if key == "IBike_HCC":
            self.adsnens = {
                "逢甲大學":["Fuxing Road & Fengjia Road, Xitun District, Taichung City, 407", "Feng Chia University", "Xitun District"],
                "秋紅谷":["Chaofu Road & Chaoma Road, Xitun District, Taichung City, 407", "Maple Garden", "Xitun District"],
                "市政府(文心樓)":["Section 2, Wenxin Road, Xitun District, Taichung City, 407", "Taichung City Government", "Xitun District"],
                "漢翔福星北路口":["Hanxiang Road & Fuxing North Road, Xitun District, Taichung City, 407", "Hanxiang Rd & Fuxing N Rd", "Xitun District"],
                "福星公園":["Lane 301, Section 2, Henan Road & Lane 50, Baoqing St, Xitun District, Taichung City, 407", "Fuxing Park", "Xitun District"],
                "櫻花棒球場":["Yinghua Road & 洛陽路 Xitun District, Taichung City, 407", "Cherry Blossoms Baseball Field", "Xitun District"],
                "重慶公園":["Section 2, Xitun Road & Tianshui West 6th St, Xitun District, Taichung City, 407", "Chongqing Park", "Xitun District"],
                "頂何厝":["Section 2, Taiwan Boulevard, Xitun District, Taichung City, 407", "Ding He Cuo", "Xitun District"],
                "公益大英街口":["Section 2, Gongyi Road & Daying Street, Nantun District, Taichung City, 408", "Gongyi Rd & Daying St", "Nantun District"],
                "新光/遠百":["Section 3, Taiwan Boulevard & Huilai Road, Xitun District, Taichung City, 407", "Xin Guang / Yuan Bai", "Xitun District"],
                "青海逢甲路口":["Section 2, Qinghai Road & Fengjia Road, Xitun District, Taichung City, 407", "Qinghai Rd & Fengjia Rd", "Xitun District"],
                "忠明國小":["No. 531, Section 2, Taiwan Boulevard, West District, Taichung City, 403", "Zhongming Elementary School", "West District"],
                "大墩七街河南路口":["No. 408, Dadun 7th Street & Section 4 Henan Road, Nantun District, Taichung City, 408", "Dadun 7th St & Henan Rd", "Nantun District"],
                "臺中仁愛醫院":["Section 1 Taiwan Boulevard, Xingzhong Street, Central District, Taichung City, 400", "Ran Ai Hospital", "Central District"],
                "博館育德路口":["Boguan Road & Yude Road, North District, Taichung City, 404", "Boguan Rd & Yude Rd", "North District"],
                "科博館/金典酒店":["No. 426, Section 2, Taiwan Boulevard, West District, Taichung City, 403", "National Museum of Natural Science/Splendor Hotel", "West District"],
                "中正國小":["Yingcai Road & Lane 179, Section 2, Taiwan Blvd, West District, Taichung City, 403", "Chungcheng Elementary School", "West District"],
                "茄苳腳":["Section 1, Xitun Road & Section 2, Meichuan E Rd, West District, Taichung City, 403", "Qiedongjiao", "West District"],
                "萬壽棒球場":["Section 1 Xiangshang Road & Dajin Street, West District, Taichung City, 403", "Wan Shou Baseball Field", "West District"],
                "公益公園":["Zhongming South Road & Gongyi Rd, West District, Taichung City, 403", "Gong Yi Park", "West District"],
                "大墩文化中心":["Wuquan Road & Yingcai Road, West District, Taichung City, 403", "Dadun Cultural Centre", "West District"],
                "英士公園":["Yingshi Rd, Rixing Street, North District, Taichung City, 404", "Yingshi Park", "North District"],
                "大隆東興路口":["No. 69, Dalong Road, West District, Taichung City, 403", "Dalong Rd & Dongxing Rd", "West District"],
                "文心森林公園":["Section 2, Xiangshang Road, Nantun District, Taichung City, 408", "Wenxin Forest Park", "Nantun District"],
                "五權西文心路口":["Section 1, Wenxin Road, Nantun District, Taichung City, 408", "Wuquan West Rd & Wenxin Rd", "Nantun District"],
                "臺中州廳":["Minquan Road & Shifu Road, West District, Taichung City, 403", "Taichung City Hall", "West District"],
                "臺中公園":["Gongyuan Road & Ziyou Road, Central District, Taichung City, 400", "Taichung Park", "Central District"],
                "臺中孔廟":["Section 2, Shuangshi Road, North District, Taichung City, 404", "Taichung Confucius Temple", "North District"],
                "育德梅川東路口":["Yude Road, North District, Taichung City, 404", "Yude Rd & Meichuan E Rd", "North District"],
                "太原北中清路口":["Taiyuan North Road & Zhongqing Road, North District, Taichung City, 404", "Taiyuan N Rd & Zhongqing Rd", "North District"],
                "臺中教育大學":["Wuquan Road, West District, Taichung City, 403", "NTCU Department of Language and Literacy Education", "West District"],
                "學士育德路口":["Xueshi Road, North District, Taichung City, 404", "Xueshi Rd & Yude Rd", "North District"],
                "中山地政事務所":["Section 8, Zhongqing Road, Qingshui District, Taichung City, 436", "Taichung City Zhongshan Land Office", "Qingshui District"],
                "市民廣場":["Gongyi Road & Zhongxing St, West District, Taichung City, 403", "Taichung Civis Square", "West District"],
                "國立自然科學博物館":["No. 101, Boguan Road, West District, Taichung City, 403", "National Museum of Natural Science", "West District"],
                "經國園道":["Yingcai Road & Xiangshang Road, West District, Taichung City, 403", "Ching Kuo Greenway//Calligraphy Greenway", "West District"],
                "國立臺灣美術館":["Section 1, Meicun Road & Section 1, Wuquan Road, West District, Taichung City, 403", "National Taiwan Museum of Fine Arts", "West District"],
                "北區行政大樓":["Yongxing Street & Section 2, Taiyuan Road, North District, Taichung City, 404", "North District Household Registration Office", "North District"],
                "三光太原路口":["Section 3, Taiyuan Road, Beitun District, Taichung City, 406", "Sanguang Rd & Taiyuan Rd", "Beitun District"],
                "北屯兒童公園":["Section 1, Xing'''an Road & Section 4, Beiping Road, Beitun District, Taichung City, 406", "Beitun Children'''s Park", "Beitun District"],
                "力行國小":["Jinhua Road, East District, Taichung City, 401", "Taichung Municipal Li Sing Elementary School", "East District"],
                "臺中一中":["Yucai Street & Zunxian Street, North District, Taichung City, 404", "Municipal Taichung First Senior High School", "North District"],
                "忠誠公園":["Section 1, Huamei W St, West District, Taichung City, 403", "Zhongcheng Park", "West District"],
                "賴明公園":["Section 3, Meichuan East Road & Section 4, HanKou Road, North District, Taichung City, 404", "LaiMin Park", "North District"],
                "國立臺中文華高中":["Section 3, Wenxin Road & Section 1, Henan Road, Xitun District, Taichung City, 407", "Taichung Municipal Wen-Hua Senior High School", "Xitun District"],
                "崇倫公園":["Section 1, Nantun Road, West District, Taichung City, 403", "Chonglun Park", "West District"],
                "臺中火車站":["No. 113, Jianguo Road, Central District, Taichung City, 400", "Taichung Railway Station", "Central District"],
                "黎明國中":["No. 610, Section 2, Liming Road, Nantun District, Taichung City, 408", "Limingguomin High School", "Nantun District"],
                "豐樂雕塑公園":["Wenxin S. 5th Rd & Xiangxin S Rd, Nantun District, Taichung City, 408", "Fongle Sculpture Park", "Nantun District"],
                "惠文高中":["No. 48 Section 2, Huizhong Road & Daye Road, Nantun District, Taichung City, 408", "HuiWen High School", "Nantun District"],
                "上石公園":["Section 2, Xitun Road & Shangshi N 5th Ln, Xitun District, Taichung City, 407", "Shangshi Park", "Xitun District"],
                "英才公園":["Yingcai Road, North District, Taichung City, 404", "Yingcai Park", "North District"],
                "中德公園":["Zhongtai East Road & Zhongming 6th St, North District, Taichung City, 404", "Zhongde Park", "North District"],
                "向心兒童公園":["Wenxin South 2nd Road, Lane 905, Xiangxin S Rd, Nantun District, Taichung City, 408", "Xiangxin Children'''s Park", "Nantun District"],
                "市政公園停車場":["Shizheng North 5th Road, Xitun District, Taichung City, 407", "Shizheng Park Parking Lot", "Xitun District"],
                "民俗公園":["Section 2, Rehe Road & Section 2, Dalian Rd, Beitun District, Taichung City, 406", "Minsu (Folklore) Park", "Beitun District"],
                "臺中國小":["Xinyi Street, East District, Taichung City, 401", "Taichung Elementary School", "East District"],
                "國立中興大學":["Xingda Road, South District, Taichung City, 402", "National Chung Hsing University", "South District"],
                "大業公園":["No. 408 Dajin St & Daye Rd, Nantun District, Taichung City, 408", "Daye Park", "Nantun District"],
                "忠孝國光路口":["Zhongxiao Road, South District, Taichung City, 402", "Zhongxiao Rd & Guoguang Rd", "South District"],
                "大智國小":["Dazhi Road, East District, Taichung City, 401", "Dazhi Elementary School", "East District"],
                "健行國小":["Jianxing Road & Jianxing Road, 664 Lane, North District, Taichung City, 404", "Jianxing Elementary School", "North District"],
                "東峰公園":["Renhe Road & Lide East Street, East District, Taichung City, 401", "Dongfeng Park (aka 228 Memorial Park)", "East District"],
                "太原華美街口":["Section 1, Taiyuan Road & Section 2, Huamei Street, North District, Taichung City, 404", "Taiyuan Rd & Huamei St", "North District"],
                "柳川東中華路口":["Section 4, Liuchuan East Road, North District, Taichung City, 404", "Liuchuan E Rd & Zhonghua Rd", "North District"],
                "忠明南美村南路口":["Meicun South Road, South District, Taichung City, 402", "Zhongming S Rd & Meicun S Rd", "South District"],
                "忠明南復興路口":["No. 790, Zhongming South Road, South District, Taichung City, 402", "Zhongming S Rd & Fuxing Rd", "South District"],
                "新福公園":["Section 2, Hanxi East Road & Section 4, Zhongshan Road, Taiping District, Taichung City, 406", "Shinfold Park", "Taiping District"],
                "積善公園":["Daming Road & Xingda Road, Dali District, Taichung City, 412", "Jishan Park Station", "Dali District"],
                "山西公園":["Section 2, Shanxi Road & Section 2, Beiping Road, North District, Taichung City, 404", "Shanxi Park", "North District"],
                "北屯區文昌國小":["No. 51-83, Section 1, Xing'''an Road, Beitun District, Taichung City, 406", "Beitun Wenchang Elementary School", "Beitun District"],
                "祥順運動公園":["Lane 87, Yichang Road, Taiping District, Taichung City, 406", "Xiangshun Sport Park", "Taiping District"],
                ""
            }
    
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
        
    def recordUBikeInfo(self, records, key):
        tbMgr = self.tbMgr
        for stn, record in records.iteritems():
            stnNO      = int(record['sno'])

            adCn       = record['ar']
            snCn       = record['sna']
            saCn       = record['sarea']

            adEn       = "Coming Soon"
            snEn       = "Coming Soon"
            saEn       = "Coming Soon"

            tot        = int(record['tot'])
            bikes      = int(record['sbi'])
            spaces     = int(record['bemp'])

            uDate      = self.strptime(record['mday'], '%Y%m%d%H%M%S')
            lat        = float(record['lat'])
            lng        = float(record['lng'])
            act        = 1
#            act        = int(record['act'])

            #Check if the stnNO exists

            checkData = ("SELECT * FROM " + key + \
                        " WHERE stnNO = '" + \
                         str(stnNO) + "'")
            print(checkData)
            if not tbMgr.checkData(checkData):
                #As the whole query needs to be in a string format while execution of query so %s should be used.
                addData = ("INSERT INTO " + key + \
                           "(stnNO, adCn, snCn, saCn," + \
                           " adEn, snEn, saEn," + \
                           " tot, bikes, spaces," + \
                           " uDate, lat, lng, act)" + \
                           " VALUES(%s, %s, %s, %s," + \
                           " %s, %s, %s, %s, %s," + \
                           " %s, %s, %s, %s, %s)")

                dataToAdd = (stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act)

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
                              " act     = %s" + \
                              " WHERE stnNO = %s")
                dataToUpdate = (adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, stnNO)

                tbMgr.updateData(updateData, dataToUpdate)
        print(key + " Updated")
            
    
    def fetchadsnEns(self):
        self.adsnEns = {}
    
    
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
    