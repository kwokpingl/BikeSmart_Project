# -*- coding: utf-8 -*-
import mysql.connector
from mysql.connector import errorcode
import MySQLdb

from datetime import datetime
from dateutil.parser import parse
import time

from TBManager import TBManager
from Fetcher import Fetcher

class XML_Decoder:
    def __init__(self, DB_NAME, USER, PWD, HOST):
        self.tbMgr = TBManager(DB_NAME, USER, PWD, HOST)
        self.urls = {}
        self.strptime = lambda date_string, format: datetime(*(time.strptime(date_string, format)[0:6]))
    
    def createTB(self, statement):
        tbMgr = self.tbMgr
        tbMgr.setTBNameArr(self.TBNames)
        tbMgr.createTBsWithStatement(statement)
    
    def setupURLsDic(self, urls):
        self.urls = urls
        self.TBNames = []
        for key in self.urls.keys():
            self.TBNames.append(key)
    
    def fetchCBikeXMLData(self):
        '''
        <BIKEStationData>
        <BIKEStation>
        <Station>
        <StationID>1</StationID>
        <StationNO>0019</StationNO>
        <StationPic>
        http://www.c-bike.com.tw/Uploads/Station/1_s.jpg
        </StationPic>
        <StationPic2>
        http://www.c-bike.com.tw/Uploads/Station/1_m.jpg
        </StationPic2>
        <StationPic3>
        http://www.c-bike.com.tw/Uploads/Station/1_l.jpg
        </StationPic3>
        <StationMap>
        http://www.c-bike.com.tw/Uploads/Station/1_map.png
        </StationMap>
        <StationName>生態園區站</StationName>
        <StationAddress>
        高雄市左營區博愛三路捷運R15生態園區站2號出口旁</StationAddress>
        <StationLat>22.676995542475076</StationLat>
        <StationLon>120.30648350715637</StationLon>
        <StationDesc>
        生態園區站（R15-2號出口）來源引用-高雄市政府工務局.</StationDesc>
        <StationNums1>7</StationNums1>
        <StationNums2>21</StationNums2>
        </Station>
        '''
        
        mainKey     = "BIKEStationData"
        secondKey   = "BIKEStation"
        thirdKey    = "Station"
        stnNOKey    = "StationNO"
        
        adCnKey     = "StationAddress"
        snCnKey     = "StationName"
        
        bikesKey    = "StationNums1"
        spacesKey   = "StationNums2"
        
        latKey      = "StationLat"
        lngKey      = "StationLon"
        
        pic1Key     = "StationPic3"
        pic2Key     = "StationMap"
        
        
        
        
        tbMgr = self.tbMgr
        for key, url in self.urls.iteritems():
            fetcher = Fetcher(url, 1)
            dataDic = fetcher.getText()
            # First Key : BIKEStationData
            dataDic = dataDic["BIKEStationData"]
            # Second Key : BIKEStationData
            dataDic = dataDic["BIKEStation"]
            
            dataArr = dataDic["Station"]
            
            self.setupAdsnens(key)
            
            for data in dataArr:
                stnNO   = data[stnNOKey]
                adCn    = data[adCnKey]
                snCn    = data[snCnKey]
                saCn    = ""
                
                adEn    = ""
                snEn    = ""
                saEn    = ""
                
                act     = 1
                
                if snCn in self.adsnEns.keys():
                    array   = self.adsnEns[snCn.encode('utf-8')]
                    adEn    = array[0]
                    snEn    = array[1]
                    saEn    = array[2]
                    saCn    = self.districtens[saEn]
                    
                else:
                    adEn    = "Unknown"
                    snEn    = "Bike Sharing Station"
                    act     = 0
                
                bikes   = data[bikesKey]
                spaces  = data[spacesKey]
                tot     = int(bikes) + int(spaces)
                # datetime.now() gives datetime with microsecond, use strfttime(format) to ge the format preferred
                uDate   = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                
                lat     = data[latKey]
                lng     = data[lngKey]
                pic1    = data[pic1Key]
                pic2    = data[pic2Key]
                
                #Check if stnNO exists
                
                checkData   = ("SELECT * FROM " + key + \
                              " WHERE stnNO = '" + \
                              str(stnNO) + "'")
                                
                if not tbMgr.checkData(checkData):
                    addData = ("INSERT INTO " + key + \
                               "(stnNO, adCn, snCn, saCn," + \
                               " adEn, snEn, saEn," + \
                               " tot, bikes, spaces," + \
                               " uDate, lat, lng, act, pic1, pic2, type)" + \
                               " VALUES(%s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s," + \
                               " %s, %s, %s, %s, %s," + \
                               " %s, %s, %s)")
                    
                    dataToAdd   =  (stnNO, adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key)
                   
                    
                    #insert
                    tbMgr.insertData(addData, dataToAdd)
                else:
                    updateData = ("UPDATE " + key + \
                                  " SET adCn    = %s," + \
                                  " snCn    = %s,"  + \
                                  " saCn    = %s,"  + \
                                  " adEn    = %s,"  + \
                                  " snEn    = %s,"  + \
                                  " saEn    = %s,"  + \
                                  " tot     = %s,"  + \
                                  " bikes   = %s,"  + \
                                  " spaces  = %s,"  + \
                                  " uDate   = %s,"  + \
                                  " lat     = %s,"  + \
                                  " lng     = %s,"  + \
                                  " act     = %s,"  + \
                                  " pic1    = %s,"  + \
                                  " pic2    = %s,"  + \
                                  " type    = %s"   + \
                                  " WHERE stnNO = %s")
                    dataToUpdate = (adCn, snCn, saCn, adEn, snEn, saEn, tot, bikes, spaces, uDate, lat, lng, act, pic1, pic2, key,stnNO)
                    
                    tbMgr.updateData(updateData, dataToUpdate)
            print(key + " Updated")
            
    def setupAdsnens(self, key):
        self.adsnEns = {}
        self.districtens = {}
        
        # ================== CBike ======================
        if key == "CBike_KS":
            
            # 沒有給區域 之後要自己加
            
            self.districtens = {
                "Daliao Dist."   :"大寮區",
                "Fengshan Dist." :"鳳山區",
                "Gangshan Dist." :"岡山區",
                "Gushan Dist."   :"鼓山區",
                "Jiading Dist."  :"茄萣區",
                "Lingya Dist."   :"苓雅區",
                "Linyuan Dist."  :"林園區",
                "Nanzi Dist."    :"楠梓區",
                "Niaosong Dist." :"鳥松區",
                "Qianjin Dist."  :"前金區",
                "Qianzhen Dist." :"前鎮區",
                "Qiaotou Dist."  :"橋頭區",
                "Qijin Dist."    :"旗津區",
                "Renwu Dist."    :"仁武區",
                "Sanmin Dist."   :"三民區",
                "Xiaogang Dist." :"小港區",
                "Xinxing Dist."  :"新興區",
                "Yancheng Dist." :"鹽埕區",
                "Yanchao Dist."  :"燕巢區",
                "Zuoying Dist."  :"左營區",
                "Ziguan Dist."   :"梓官區"
            }
            
            self.adsnEns = {
            "生態園區站":["Bo'ai 3rd Road, Zuoying District, Kaohsiung City, 813", "Ecological District (MRT)", "Zuoying Dist."],
            "巨蛋站":["Bo'ai 2nd Road, Zuoying District, Kaohsiung City, 813", "Kaohsiung Arena Station", "Zuoying Dist."],
            "凹仔底站":["Bo'ai 2nd Road, Gushan District, Kaohsiung City, 804", "Aozihdi", "Gushan Dist."],
            "後驛站":["Bo'ai 1st Road, Sanmin District,  Kaohsiung City, 807", "Houyi", "Sanmin Dist."],
            "後火車站":["Jiuru 2nd Road, Sanmin District, Kaohsiung City, 807", "Hou Train Station", "Sanmin Dist."],
            "美麗島站":["Liuhe 2nd Road, Xinxing District, Kaohsiung City, 800", "Formosa Boulevard (MRT)", "Xinxing Dist."],
            "中央公園站":["Zhongshan 2nd Road, Qianjin District, Kaohsiung City, 801", "Central Park (MRT)", "Qianjin Dist."],
            "三多站":["Lingya District, Kaohsiung City, 802", "Sanduo Shopping District (MRT)", "Lingya Dist."],
            "新光中山站":["Zhongshan 2nd Road, Qianzhen District, Kaohsiung City, 806", "Singuang Zhongshan", "Qianzhen Dist."],
            "獅甲站":["Zhongshan 3rd Road, Qianzhen District, Kaohsiung City, 806", "Shihjia (MRT)", "Qianzhen Dist."],
            "凱旋站":["Zhongshan 3rd Road, Qianzhen District, Kaohsiung City, 806", "Kaisyuan (MRT)", "Qianzhen Dist."],
            "西子灣站":["Gushan 1st Road, Gushan District, Kaohsiung City, 804", "Sizihwan (MRT)", "Gushan Dist."],
            "鹽埕埔站":["Dayong Road, Yancheng District, Kaohsiung City, 803", "Yanchengpu (MRT)", "Yancheng Dist."],
            "市議會(舊址)站":["Zhonghua 3rd Road, Qianjin District, Kaohsiung City, 801", "City Council Former Site (MRT)", "Qianjin Dist."],
            "新興區公所站":["Jintian Road, Xinxing District, Kaohsiung City, 800", "Sinsing District Office", "Xinxing Dist."],
            "文化中正站":["Heping 1st Road, Lingya District, Kaohsiung City, 802", "Cultural Center (MRT)", "Lingya Dist."],
            "五塊厝站":["Zhongzheng 1st Road, Lingya District, Kaohsiung City, 802", "Wukuaicuo (MRT)", "Lingya Dist."],
            "技擊館站":["Zhongzheng 1st Road, Lingya District, Kaohsiung City, 802", "Martial Arts Stadium (MRT)", "Lingya Dist."],
            "衛武營站":["Zhongzheng 1st Road, Lingya District, Kaohsiung City, 802", "Weiwuying(MRT)", "Lingya Dist."],
            "大東文化藝術中心站-01":["Guangyuan Road, Fengshan District, Kaohsiung City, 830", "Da-Dong Art Center-01", "Fengshan Dist."],
            "大東文化藝術中心站-02":["Dadong 1st Road, Fengshan District, Kaohsiung City, 830", "Da-Dong Art Center-02", "Fengshan Dist."],
            "捷運鳳山站":["Guangyuan Road, Fengshan District, Kaohsiung City, 830", "Fongshan(MRT)", "Fengshan Dist."],
            "捷運鳳山西站":["Ziyou Road, Fengshan District, Kaohsiung City, 830", "Fongshan West(MRT)", "Fengshan Dist."],
            "捷運小港站":["Yanhai 1st Road, Xiaogang District, Kaohsiung City, 812", "Siaogang(MRT)", "Xiaogang Dist."],
            "捷運青埔站":["Jingwu Road, Qiaotou District, Kaohsiung City, 825", "Cingpu(MRT)", "Qiaotou Dist."],
            "捷運南岡山站":["Gangshan South Road, Gangshan District, Kaohsiung City, 820", "Gangshan South( MRT)", "Gangshan Dist."],
            "捷運世運主場館站":["Shiyun Boulevard, Zuoying District, Kaohsiung City, 813", "World Games(MRT)", "Zuoying Dist."],
            "捷運楠梓加工出口區站":["Jiachang Road, Nanzi District, Kaohsiung City, 811", "Nanzih Export Processing Zone(MRT)", "Nanzi Dist."],
            "捷運都會公園站(暫停營運)":["Gaonan Road, Nanzi District, Kaohsiung City, 811", "Metropolitan Park(MRT)", "Nanzi Dist."],
            "高雄國際機場站":["Zhongshan 4th Road, Xiaogang District, Kaohsiung City, 812", "Kaohsiung International Airport(MRT)", "Xiaogang Dist."],
            "草衙站":["Cuiheng South Road, Qianzhen District, Kaohsiung City, 806", "Caoya(MRT)", "Qianzhen Dist."],
            "福誠高中站":["Wujia 3rd Road, Fengshan District, Kaohsiung City, 830", "Fucheng Senior High School", "Fengshan Dist."],
            "福裕停車場站(暫停營運)":["802, Kaohsiung City, Lingya Dist.", "Fu Yu Parking Lot", "Lingya Dist."],
            "南華市場站":["Zhongzheng 3rd Road, Xinxing District, Kaohsiung City, 800", "Nanhua Market", "Xinxing Dist."],
            "郵政總局站":["Xinxing District, Kaohsiung City, 800", "	Kaohsiung General Post Office", "Xinxing Dist."],
            "高鐵左營站":["Gaotie Road, Zuoying District, Kaohsiung City, 813", "Zuoying Station THSR", "Zuoying Dist."],
            "巨蛋站(2)":["Bo'ai 2nd Road, Zuoying District, Kaohsiung City, 813", "Kaohsiung Arena (MRT) 2", "Zuoying Dist."],
            "後驛站(2)":["Bo'ai 1st Road, Sanmin District, Kaohsiung City, 807", "Houyi (MRT) 2", "Sanmin Dist."],
            "中央公園站(2)":["Zhongshan 2nd Road, Qianjin District, Kaohsiung City, 801", "Central Park (MRT) 2", "Qianjin Dist."],
            "三多站(2)":["Lingya District, Kaohsiung City, 802", "Sanduo Shopping District (MRT) 2", "Lingya Dist."],
            "文化中正站(2)":["Heping 1st Road, Lingya District, Kaohsiung City, 802", "Cultural Center (MRT) 2", "Lingya Dist."],
            "前鎮高中站":["Cuiheng North Road, Qianzhen District, Kaohsiung City, 806", "Cianjhen Senior High School (MRT)", "Qianzhen Dist."],
            "台鐵新左營站":["Zhanqian North Road, Zuoying District, Kaohsiung City, 813", "Xinzuoying(TRA)", "Zuoying Dist."],
            "捷運鳳山國中站":["Zhongshan East Road, Fengshan District, Kaohsiung City, 830", "Fongshan Junior High School (MRT)", "Fengshan Dist."],
            "捷運後勁站":["Nanzi District, Kaohsiung City, 811", "Houjing Station (MRT)", "Nanzi Dist."],
            "捷運大寮站":["Jiexi Road, Daliao District, Kaohsiung City, 831", "Daliao(MRT)", "Daliao Dist."],
            "輔英科技大學站":["Daliao District, Kaohsiung City, 831", "Fooyin University", "Daliao Dist."],
            "願景橋站":["Hexi 1st Road, Gushan District, Kaohsiung City, 804", "Yuanjing Bridge (MRT)", "Gushan Dist."],
            "福山國中站":["Ziyou 4th Road, Zuoying District, Kaohsiung City, 813", "Fushan Junior High School", "Zuoying Dist."],
            "鼓山渡船頭站":["Gubo Street, Gushan District, Kaohsiung City, 804", "Gushan Ferry Pier", "Gushan Dist."],
            "五甲公園站":["Ruinan Street, Qianzhen District, Kaohsiung City, 806", "Wujia Park", "Qianzhen Dist."],
            "三民游泳池站":["Ziyou 1st Road, Sanmin District, Kaohsiung City, 807", "Sanmin Swimming Pool", "Sanmin Dist."],
            "美術東二路站":["Meishu East 2nd Road, Gushan District, Kaohsiung City, 804", "Meishu East 2nd Road", "Gushan Dist."],
            "新民國小站":["Ziyou 3rd Road, Zuoying District, Kaohsiung City, 813", "Xin Min Elementary School Station", "Zuoying Dist."],
            "雄鋒公園站":["Jiuru 4th Road, Gushan District, Kaohsiung City, 804", "Hsiung Feng Park", "Gushan Dist."],
            "果貿社區站":["Cuihua Road, Zuoying District, Kaohsiung City, 813", "Guomao Community", "Zuoying Dist."],
            "WO旅店站":["No. 394, Qixian 2nd Road, Qianjin District, Kaohsiung City, 801", "HOTEL WO Station", "Qianjin Dist."],
            "中山大學海工館站":["Lianhai Road, Gushan District, Kaohsiung City, 804","National Sun Yat-Sen University: Department of Marine Environment and Engineering", "Gushan Dist."], 
            "新莊國小站":["Xinzhuangzi Rd, Zuoying District, Kaohsiung City, 813", "Xinzhuang Elementary School", "Zuoying Dist."],
            "輔英科技大學站(2)":["Daliao District, Kaohsiung City, 831", "Fooyin University(2)", "Daliao Dist."],
            "楠梓高中站":["No. 19, Qingfeng Road, Nanzi District, Kaohsiung City, 811", "Nan Zi High School", "Nanzi Dist."],
            "文府國小站":["Wenfu Road, Zuoying District, Kaohsiung City, 813", "Wenfu Elementary School", "Zuoying Dist."],
            "台鋁站(1)":["Zhongqin Road, Qianzhen District, Kaohsiung City, 806", "MLD Cinema 1", "Qianzhen Dist."],
            "台鋁站(2)":["Zhongqin Road, Qianzhen District, Kaohsiung City, 806", "MLD Cinema 2", "Qianzhen Dist."],
            "步道公園站":["Pinghe West Road, Xiaogang District, Kaohsiung City, 812", "Walking Park", "Xiaogang Dist."],
            "龍華市場站":["Zhongyan Road, Zuoying District, Kaohsiung City, 813", "Longhua Public Market", "Zuoying Dist."],
            "檨仔林埤濕地公園站":["Dingjinhou Rd, Sanmin District, Kaohsiung City, 807", "She Tzai Lin Pi Wetland Park", "Sanmin Dist."],
            "臺灣高雄少年及家事法院站":["Changshun Street, Nanzi District, Kaohsiung City, 811", "Taiwan Kaohisung Juvenile and Family Court", "Nanzi Dist."], 
            "仁和公園站":["Renyong W Ln, Renwu District, Kaohsiung City, 814", "Renhe Park", "Renwu Dist."],
            "鳳東公園站":["Zhongshan East Road, Fengshan District, Kaohsiung City, Lane 290, 830", "Fengdong Park", "Fengshan Dist."],
            "市立歷史博物館站":["Yancheng District, Kaohsiung City, 803", "Kaohsiung Museum of History", "Yancheng Dist."],
            "龍華國中站":["Yancheng District, Kaohsiung City, 813", "Longhua Junior High School", "Yancheng Dist."],
            "竹林公園站":["Longfeng Road, Qiaotou District, Kaohsiung City, 825", "Bamboo Grove Park", "Qiaotou Dist."],
            "河北立德站":["Hebei 2nd Road, Sanmin District, Kaohsiung City, 807", "Hebei Lide", "Sanmin Dist."],
            "介壽先鋒站":["Jieshou Road, Zuoying District, Kaohsiung City, 813", "Jieshou-Xianfeng", "Zuoying Dist."],
            "城市光廊站":["Zhonghua 3rd Road, Qianjin District, Kaohsiung City, 801", "City Guang Lang", "Qianjin Dist."],
            "慈濟靜思堂站":["Ziyou 1st Road, Sanmin District, Kaohsiung City, 807", "Tzuchi Jing Si Tang", "Sanmin Dist."],
            "民族國中站":["Dachang 2nd Road, Sanmin District, Kaohsiung City, 807", "Minzu Junior High School", "Sanmin Dist."],
            "武漢里活動中心站":["Wuying Road, Lane 239, Fengshan District, Kaohsiung City, 830", "Wuhan Community Center", "Fengshan Dist."],
            "大灣國中站":["Renxiong Road, Renwu District, Kaohsiung City, 814", "Da Wan Junior High School", "Renwu Dist."],
            "海光兒童公園站":["Ruida Street, Fengshan District, Kaohsiung City, 830", "Haiguang Children's Park", "Fengshan Dist."],
            "漁港公園站":["Linyuan District, Kaohsiung City, 832", "Harbor Park", "Linyuan Dist."],
            "八仙公園站":["Guotai Road, Section 1, Fengshan District, Kaohsiung City, 830", "Baxian Park", "Fengshan Dist."],
            "明誠高中站":["Huaning Road, Gushan District, Kaohsiung City, 804", "Tianzhujiaomingcheng High School", "Gushan Dist."],
            "管仲民裕站":["Minyu Street, Qianzhen District, Kaohsiung City, 806", "Guanzhong", "Qianzhen Dist."],
            "鼓山國小站":["Linhai 2nd Road, Gushan District, Kaohsiung City, 804", "Gushan Elementary School", "Gushan Dist."],
            "陽明公園站":["Chenghe Road, Sanmin District, Kaohsiung City, 807", "Yang Ming Park", "Sanmin Dist."],
            "鳳儀書院站":["Zhongzheng Road, Lane 129, Fengshan District, Kaohsiung City, 830", "Fongyi Academy", "Fengshan Dist."],
            "鳳山公園站":["Yuanmao Road, Fengshan District, Kaohsiung City, 830", "Fengshan Park", "Fengshan Dist."],
            "空中大學站":["Xiaogang District, Kaohsiung City, 812", "Open University of Kaohsiung", "Xiaogang Dist."],
            "瑞祥高中站":["Kaisyuan 4th Road, Qianzhen District, Kaohsiung City, 806", "Rueisiang Senior High School", "Qianzhen Dist."],
            "金獅湖橋站":["Dingjinhou Rd, Sanmin District, Kaohsiung City, 807", "Jinshi Lake Bridge", "Sanmin Dist."],
            "台糖楠梓量販店站":["No. 79, Qingfeng 1st Road, Nanzi District, Kaohsiung City, 811", "Taisuco Station", "Nanzi Dist."],
            "右昌森林公園站":["Jiahong Road, Nanzi District, Kaohsiung City, 811", "Youchang Forest Park", "Nanzi Dist."],
            "華夏西北扶輪公園站":["Zuoying District, Kaohsiung City, 813", "Huaxiaxibei Park", "Zuoying Dist."],
            "圖書總館站(2)":["Xinguang Road, Qianzhen District, Kaohsiung City, 806", "Kaohsiung Main Public Library", "Qianzhen Dist."],
            "岡山高中站":["Gongyuan Road, Gangshan District, Kaohsiung City, 820", "Gang Shan High School", "Gangshan Dist."],
            "新甲國小站":["Xinqiang Road, Fengshan District, Kaohsiung City, 830", "Hsin Chya Elementary School", "Fengshan Dist."],
            "三信家商站":["Sanduo 1st Road, Lingya District, Kaohsiung City, 802", "Private Sanxin High School of Commerce of Kaosiung City", "Lingya Dist."],
            "大同醫院站":["Datong 1st Road & Chunghua 3rd Road, Qianjin District, Kaohsiung City, 801", "Kaohsiung Datong Hospital", "Qianjin Dist."],
            "公二公園站":["Zhengyi Road, Sanmin District, Kaohsiung City, 807", "GongEr Park", "Sanmin Dist."],
            "後備指揮部站":["Wugong Ln, Renwu District, Kaohsiung City, 814", "Kaohsiung City Reserve Command General Headquarters", "Renwu Dist."],
            "三民高中站":["Jinding Road, Sanmin District, Kaohsiung City, 807", "Sanmin Senior High School Station", "Sanmin Dist."],
            "家樂福鼎山站":["No. 529, Dingshan Street, Sanmin District, Kaohsiung City, 807", "Carrefour Ding Shan Store", "Sanmin Dist."],
            "新光國小站":["Cengzi Road, Zuoying District, Kaohsiung City, 813", "Xinguang Elementary School", "Zuoying Dist."],
            "新莊高中站":["Wenci Road, Zuoying District, Kaohsiung City, 813", "Kaohsiung Municipal Hsin-Chuang Senior High School", "Zuoying Dist."],
            "海青工商站":["Zuoying Ave, Zuoying District, Kaohsiung City, 813", "Hai Qing Vocational Senior High School", "Zuoying Dist."],
            "合群新城和區站":["Weijiu Road, Zuoying District, Kaohsiung City, 813", "Tsoying Community", "Zuoying Dist."],
            "富國公園站":["No. 294-298, Fuguo Road, Zuoying District, Kaohsiung City, 813", "Fuguo Park", "Zuoying Dist."],
            "鼓山高中站":["Qinghai Road, Gushan District, Kaohsiung City, 804", "Kaohsiung Minicipal Ku Shan High School", "Gushan Dist."],
            "仁武區運動公園站":["Renxin Ln, Renwu District, Kaohsiung City, 814", "Renwu Sports Park", "Renwu Dist."],
            "旗津醫院站":["Qigang Road, Qijin District, Kaohsiung City, 805", "Cijin Hospital", "Qijin Dist."],
            "興達港站(2)":["Minyou Road, Jiading District, Kaohsiung City, 852", "Singda Harbor 2", "Jiading Dist."],
            "明德國小站":["Haifu Road, Zuoying District, Kaohsiung City, 813", "Mingde Elementary School", "Zuoying Dist."],
            "朝陽寺站":["Heyun Street, Qianzhen District, Kaohsiung City, 806", "Chaoyang Temple", "Qianzhen Dist."],
            "中山大學社科院站":["No. 70, Lianhai Road, Gushan District, Kaohsiung City, 804", "National Sun Yat-sen University", "Gushan Dist."],
            "橋頭地檢署站":["Jingwu Road, Qiaotou District, Kaohsiung City, 825", "Taiwan Ciaotou District Court", "Qiaotou Dist."],
            "生日公園站":["No. 184-196, Siwei 3rd Road, Lingya District, Kaohsiung City, 802", "Birthday Park", "Lingya Dist."],
            "蚵仔寮觀光魚市站":["Ziguan District, Kaohsiung City, 826", "Keziliao Fishing Harbor", "Ziguan Dist."],
            "鳳山共同市場站":["Gongxie St, Fengshan District, Kaohsiung City, 830", "Fengshan Common Market", "Fengshan Dist."],
            "長庚醫院站":["Niaosong District, Kaohsiung City, 833", "Kaohsiung Chang Gung Memorial Hospital", "Niaosong Dist."],
            "鐵道文化園區站(1)":["Gushan District, Kaohsiung City, 804", "Railway Culture Park 1", "Gushan Dist."],
            "鐵道文化園區站(2)":["Gushan District, Kaohsiung City, 804", "Railway Culture Park 2", "Gushan Dist."],
            "茄萣海岸公園站":["Binhai Road, Section 3, Jiading District, Kaohsiung City, 852", "Jiading Coast Park", "Jiading Dist."],
            "建民公園站":["No. 34, Xingchang Street, Sanmin District, Kaohsiung City, 807", "Jianmin Park", "Sanmin Dist."],
            "前鎮國中站":["Qianzhen District, Kaohsiung City, 806", "Municipal Qianzhen Junior High School", "Qianzhen Dist."],
            "愛河之心站(2)":["Tianjin Street, Sanmin District, Kaohsiung City, 807", "Heart of the Lover River 2", "Sanmin Dist."],
            "曹公圳公園站":["Dadong 2nd Road, Fengshan District, Kaohsiung City, 830", "CaoGong Canal Park", "Fengshan Dist."],
            "精華公園站":["Jinzhou Street, Sanmin District, Kaohsiung City, 807", "Jing Hua Park", "Sanmin Dist."],
            "扶輪公園站":["Bo'ai 4th Road, Zuoying District, Kaohsiung City, 813", "Bo'aifulun Park", "Zuoying Dist."],
            "高雄榮總站":["No. 141, Rongzong Road, Zuoying District, Kaohsiung City, 813", "Kaohsiung Veterans General Hospital", "Zuoying Dist."],
            "岡山河堤公園站":["Renyi Road-Section 2, Hedi Road, Gangshan District, Kaohsiung City, 820", "Gangshanhedi Park", "Gangshan Dist."],
            "岡山稽徵所站":["Jianying South Road, Lane 42, Gangshan District, Kaohsiung City, 820", "Gang Shan Revenue Service ( National Taxation Bureau )", "Gangshan Dist."],
            "岡山忠孝里站":["Gangshan District, Kaohsiung City, 820", "Zhongxiao", "Gangshan Dist."],
            "岡山文化中心站":["Gangshan South Road, Gangshan District, Kaohsiung City, 820", "Gang Shan Cultural Center", "Gangshan Dist."],
            "原住民故事館站":["Cuiheng North Road, Qianzhen District, Kaohsiung City, 806", "Indigenous Affairs Commission", "Qianzhen Dist."],
            "消防局站":["No. 119, Kaisyuan 4th Road, Qianzhen District, Kaohsiung City, 806", "Fire Bureau", "Qianzhen Dist."],
            "前鎮加工區站(1)":["Qianzhen District, Kaohsiung City, 806", "Qianzhen Export Processing Zone 1", "Qianzhen Dist."],
            "前鎮加工區站(2)":["Qianzhen District, Kaohsiung City, 806", "Qianzhen Export Processing Zone 2", "Qianzhen Dist."],
            "文化中心站":["Heping 1st Road, Lingya District, Kaohsiung City, 802", "Cultural Center (MRT)", "Lingya Dist."],
            "正義市場站":["Wenchang Road, Lingya District, Kaohsiung City, 802", "Zhengyi Market", "Lingya Dist."],
            "高雄高商站":["Wufu 2nd Road & Fuxing 2nd Road, Xinxing District, Kaohsiung City, 800", "Kaohsiung Commercial High School", "Xinxing Dist."],
            "高雄監理所站":["Wulin Road, Fengshan District, Kaohsiung City, 830", "Kaohsiung Motor Vehicle Office, Directorate General of Highways", "Fengshan Dist."],
            "楠梓翠屏站":["Nanzi District, Kaohsiung City, 811", "Nanzi Cuiping Station", "Nanzi Dist."],
            "鳳新高中站(2)":["Xinkang Street, Fengshan District, Kaohsiung City, 830", "Feng Hsin Senior High School 2", "Fengshan Dist."],
            "森林公園站(2)":["Zhisheng Road, Gushan District, Kaohsiung City, 804", "Aozihdi Forest Park 2", "Gushan Dist."],
            "高雄真愛館站":["Bixin Street, Yancheng District, Kaohsiung City, 803", "Kaohsiung Chenai", "Yancheng Dist."],
            "興達港站":["Zhengda Road, Jiading District, Kaohsiung City, 852", "Singda Harbor 1", "Jiading Dist."],
            "小港醫院站":["Xiaogang District, Kaohsiung City, 812", "Hsiaokang Hospital", "Xiaogang Dist."],
            "自由市場站":["Ziyou 3rd Road, Zuoying District, Kaohsiung City, 813", "Evening Market", "Zuoying Dist."],
            "文山高中站":["Gongyuan Road, Niaosong District, Kaohsiung City, 833", "Wen Shan High School", "Niaosong Dist."],
            "市府鳳山行政中心站(2)":["Chengqing Road, Fengshan District, Kaohsiung City, 830", "Kaohsiung City Government Fengshan Administration Center", "Fengshan Dist."],
            "澄清湖站(3)":["Chengqing Road, Niaosong District, Kaohsiung City, 833", "Chengcing Lake 3", "Niaosong Dist."],
            "澄清湖站(4)":["Niaosong District, Kaohsiung City, 833", "Chengcing Lake 4", "Niaosong Dist."],
            "澄清湖站(5)":["Niaosong District, Kaohsiung City, 833", "Chengcing Lake 5", "Niaosong Dist."],
            "大寮區公所站":["No. 492, Fenglin 3rd Road, Daliao District, Kaohsiung City, 831", "Kaohsiung City Daliao District Office", "Daliao Dist."],
            "長青綜合服務中心站":["No. 326, Yingming Road, Lingya District, Kaohsiung City, 802", "Kaohsiung Public Bike - Senior Citizen's Service Center Station", "Lingya Dist."],
            "翠平公園站":["Cuiheng South Road, Xiaogang District, Kaohsiung City", "Cuiping Park", "Xiaogang Dist."],
            "中鋼成功站":["Zhongqin Road, Qianzhen District, Kaohsiung City, 806", "China Steel Chenggong", "Qianzhen Dist."],
            "聖和公園站":["Heping 2nd Road, Qianzhen District, Kaohsiung City, 806", "Shenghe Park", "Qianzhen Dist."],
            "圖書總館站":["Xinguang Road, Qianzhen District, Kaohsiung City, 806", "Kaohsiung Main Public Library", "Qianzhen Dist."],
            "中山公園站":["No. 13, Guotai Road, Section 1, Fengshan District, Kaohsiung City, 830", "Zhongshan Park", "Fengshan Dist."],
            "高雄監理所(武營)站":["Wulin Road, Fengshan District, Kaohsiung City, 830", "Kaohsiung Motor Vehicle Office, Directorate General of Highways", "Fengshan Dist."],
            "美術館馬卡道站":["Meishuguan Rd, Gushan District, Kaohsiung City, 804", "Meishuguan Makatao Station", "Gushan Dist."],
            "福山廣場站":["No. 413, Wenchuan Road, Zuoying District, Kaohsiung City, 813", "Fushan Square", "Zuoying Dist."],
            "阿公店水庫站":["Gongcheng Road, Yanchao District, Kaohsiung City, 824", "A-kung-tien Reservoir Station", "Yanchao Dist."],
            "澄清湖站(2)":["Niaosong District, Kaohsiung City, 814", "Chengcing Lake 2", "Niaosong Dist."],
            "寶業里滯洪池站":["Baoyang East Street, Sanmin District, Kaohsiung City, 807", "Baoye Detention basin", "Sanmin Dist."],
            "陽明溜冰場站":["Yihua Road, Sanmin District, Kaohsiung City, 807", "Yangming Skating Rink", "Sanmin Dist."],
            "義民廟站":["No. 8-1, Jianjun Rd, Lingya District, Lane 8, Kaohsiung City, 802", "Yimin Temple", "Lingya Dist."],
            "鼎泰廣場站":["Dingrui Street, Sanmin District, Kaohsiung City, 807", "Ding Tai Plaza", "Sanmin Dist."],
            "平和停車場站":["Pinghe 5th Road, Xiaogang District, Kaohsiung City, 812", "Pinghe Parking Lot", "Xiaogang Dist."],
            "小港區公所站":["Xiaogang District, Kaohsiung City, 812", "Siaogang District Office", "Xiaogang Dist."],
            "和春技術學院站(1)":["Daliao District, Kaohsiung City, 831", "Fortune Institute of Technology 1", "Daliao Dist."],
            "和春技術學院站(2)":["Xinyi Road, Daliao District, Kaohsiung City, 831", "Fortune Institute of Technology 2", "Daliao Dist."],
            "文化師大站(2)":["Heping 1st Road, Lingya District, Kaohsiung City, 802", "Cultural Normal Station", "Lingya Dist."],
            "光華公園站(2)":["Minyu Street, Qianzhen District, Kaohsiung City, 806", "Guanghua Park 2", "Qianzhen Dist."],
            "海科大旗津站(1)":["Zhongzhou 3rd Road, Qijin District, Kaohsiung City, 805", "National Kaohsiung Marine University Cijin District 1", "Qijin Dist."],
            "海科大旗津站(2)":["Zhongzhou 3rd Road, Qijin District, Kaohsiung City, 805", "National Kaohsiung Marine University Cijin District 2", "Qijin Dist."],
            "鳳新高中站":["No. 257, Xinfu Road, Fengshan District, Kaohsiung City, 830", "Feng-Hsin Senior High School", "Fengshan Dist."],
            "市府四維站(2)":["Siwei 3rd Road, Lingya District, Kaohsiung City, 802", "Sihwei Administration Center", "Lingya Dist."],
            "高雄女中站(2)":["Wufu 3rd Road, Qianjin District, Kaohsiung City, 801", "Kaohsiung Girls' Senior High School", "Qianjin Dist."],
            "高雄醫學大學站(2)":["Tongmeng 1st Road, Sanmin District, Kaohsiung City, 807", "Kaohsiung Medical University", "Sanmin Dist."],
            "高雄醫學大學站":["Tongmeng 1st Road, Sanmin District, Kaohsiung City, 807", "Kaohsiung Medical University", "Sanmin Dist."],
            "孔廟站":["Zuoying District, Kaohsiung City, 813", "Confucius Temple", "Zuoying Dist."],
            "民族八德站":["Minzu 2nd Road, Xinxing District, Kaohsiung City, 800", "Minzu-Bade Road", "Xinxing Dist."],
            "高雄大學站":["No. 700, Gaoxiongdaxue Rd, Nanzi District, Kaohsiung City, 811", "National University of Kaohsiung", "Nanzi Dist."],
            "中山高中站":["Lantian Road, Nanzi District, Kaohsiung City, 811", "Zhongshan High School Station", "Nanzi Dist."],
            "龍華國小站":["Nanping Road, Gushan District, Kaohsiung City, 804", "Lonhua Elementary School", "Gushan Dist."],
            "道明中學站":["No. 352, Jianguo 1st Road, Lingya District, Kaohsiung City, 802", "St. Dominic Catholic High School", "Lingya Dist."],
            "英明公園站":["Yingming Road, Lingya District, Kaohsiung City, 802", "Ying Ming Park", "Lingya Dist."],
            "四維公園站":["Siwei 4th Road, Lingya District, Kaohsiung City, 802", "Siwei Park", "Lingya Dist."],
            "正修大學站":["Chengqing Road, Niaosong District, Kaohsiung City, 833", "Cheng Shiu University", "Niaosong Dist."],
            "佛公國小站":["Fudao Road, Qianzhen District, Kaohsiung City, 806", "Fo Gong Elementary School", "Qianzhen Dist."],
            "海洋局站":["Qianzhen District, Kaohsiung City, 806", "Kaohsiung City Marine Bureau", "Qianzhen Dist."],
            "二聖公園站":["Guanghua 2nd Road, Qianzhen District, Kaohsiung City, 806", "Er Sheng Park", "Qianzhen Dist."],
            "左營高中站":["No. 55, Haigong Road, Zuoying District, Kaohsiung City, 813", "Zuoying High School", "Zuoying Dist."],
            "蓮潭會館站":["Chongde Road, Zuoying District, Kaohsiung City, 813", "Garden Villa", "Zuoying Dist."],
            "高雄第一科技大學站":["Nanzi District, Kaohsiung City, 811", "National Kaohsiung First University of Science and Technology (NKFUST)", "Nanzi Dist."],
            "加昌國小站":["Shoumin Road, Nanzi District, Kaohsiung City, 811", "Jiachang Elementary School", "Nanzi Dist."],
            "世運主場館站":["Zuoying District, Kaohsiung City, 813", "World Games", "Zuoying Dist."],
            "岡山區公所站":["No. 343, Gangshan Road, Gangshan District, Kaohsiung City, 820", "Kaohsiung City Gangshan District Office", "Gangshan Dist."],
            "西子樓站":["Lianhai Road, Gushan District, Kaohsiung City, 804", "Sun Yat-Sen Alumni House", "Gushan Dist."],
            "龍虎塔站":["No. 110, Shengli Road, Zuoying District, Kaohsiung City, 813", "Dragon and Tiger Pagoda", "Zuoying Dist."],
            "右昌圖書館站":["No. 72, Lanchang Road, Nanzi District, Kaohsiung City, 811", "Kaohsiung Public Library(Youchang)", "Nanzi Dist."],
            "中鋼台船站":["Zhonggang Road, Xiaogang District, Kaohsiung City, 812", "China Ship Building Corporation", "Xiaogang Dist."],
            "金獅湖站":["Sanmin District, Kaohsiung City, 807", "Jinshi Lake Bus Station", "Sanmin Dist."],
            "文藻外語大學站":["Sanmin District, Kaohsiung City, 807", "Wen Zao Foreign Languages University( Ding Zhong Rd.)", "Sanmin Dist."],
            "莊敬公園站":["No. 807, Mingcheng 1st Road, Sanmin District, Kaohsiung City, 807", "Zhuangjing Park", "Sanmin Dist."],
            "高雄高工站":["Sanmin District, Kaohsiung City, 807", "Kaohsiung Municipal Kaohsiung Industrial High School", "Sanmin Dist."],
            "鼎金國小站":["No. 214, Dachang 1st Road, Sanmin District, Kaohsiung City, 807", "Ding Jin Elementary School", "Sanmin Dist."],
            "餐旅高中站":["Songhe Road, Xiaogang District, Kaohsiung City, 812", "Hospitality Senior High School", "Xiaogang Dist."],
            "社教館站":["Gushan District, Kaohsiung City, 812", "Social Education Center", "Gushan Dist."],
            "班超公園站":["Banchao Road, Qianzhen District, Kaohsiung City, 806", "Banchao Park", "Qianzhen Dist."],
            "高雄中學站":["Jianguo 3rd Road, Sanmin District, Kaohsiung City, 807", "Kaohsiung Senior High school", "Sanmin Dist."],
            "博愛國小站":["Shiquan 1st Road, Sanmin District, Kaohsiung City, 807", "Bo'ai Elementary School", "Sanmin Dist."],
            "客家文物館站":["No. 215, Tongmeng 2nd Road, Sanmin District, Kaohsiung City, 807", "Hakka Cultural Museum", "Sanmin Dist."],
            "明堤公園站":["No. 171, Mingren Road, Sanmin District, Kaohsiung City, 807", "Mingdi Park", "Sanmin Dist."],
            "微笑公園站":["Zuoying District, Kaohsiung City, 813", "Weixiao Park", "Zuoying Dist."],
            "左營國小站":["Junxiao Road, Zuoying District, Kaohsiung City, 813", "Zuoying Elementary School", "Zuoying Dist."],
            "市府鳳山行政中心站":["No. 190, Chengqing Road, Fengshan District, Kaohsiung City, 830", "Kaohsiung City Government Fengshan Administration Center", "Fengshan Dist."],
            "澄清湖站":["Chengqing Road, Niaosong District, Kaohsiung City, 833", "Chengcing Lake", "Niaosong Dist."],
            "鳳凌廣場站":["Tiyu Road, Fengshan District, Kaohsiung City, 830", "Fengshan Flying Square", "Fengshan Dist."],
            "市議會(新址)站":["Fengshan District, Kaohsiung City, 830", "City Council(New)", "Fengshan Dist."],
            "美術館藝片天站":["No. 68, Meishu East 1st Road, Gushan District, Kaohsiung City, 804", "Chung-Hwa School of Arts", "Gushan Dist."],
            "蓮池潭站":["Huantan Road, Zuoying District, Kaohsiung City, 813", "Lotus Pond", "Zuoying Dist."],
            "裕誠辛亥站":["Yucheng Road, Zuoying District, Kaohsiung City, 813", "Yucheng Xinhai", "Zuoying Dist."],
            "明誠光興站":["Mingcheng 2nd Road, Zuoying District, Kaohsiung City, 813", "Mingcheng Guangsing", "Zuoying Dist."],
            "華榮公園站":["Wenxin Road, Gushan District, Kaohsiung City, 804", "Huarong Park", "Gushan Dist."],
            "森林公園站":["Shennong Road, Gushan District, Kaohsiung City, 804", "Aozihdi Forest Park", "Gushan Dist."],
            "鳳山火車站":["Xiehe Road, Fengshan District, Kaohsiung City, 830", "Fengshan Station", "Fengshan Dist."],
            "愛河之心站":["Bo'ai 1st Road, Sanmin District, Kaohsiung City, 807", "Heart of the Lover River", "Sanmin Dist."],
            "科工館站":["Jiuru 1st Road, Sanmin District, Kaohsiung City, 807", "National Science and Technology Museum", "Sanmin Dist."],
            "中山大學站":["No. 51, Lianhai Road, Gushan District, Kaohsiung City, 804", "National Sun Yat-sen University", "Gushan Dist."],
            "漁人碼頭站":["Penglai Road, Gushan District, Kaohsiung City, 804", "Fisherman's Wharf", "Gushan Dist."],
            "高雄電影館站":["Hexi Road, Yancheng District, Kaohsiung City, 803", "Kaohsiung Film Archive", "Yancheng Dist."],
            "家樂福愛河站":["Hedong Road, Sanmin District, Kaohsiung City, 807", "Carrefour Love River Store", "Sanmin Dist."],
            "市警局站":["Zhongzheng 4th Rd, Qianjin District, Kaohsiung City, 801", "Kaohsiung City Government Police Bureau", "Qianjin Dist."],
            "國賓飯店站":["Hedong Road, Qianjin District, Kaohsiung City, 801", "Ambassador Hotel", "Qianjin Dist."],
            "高雄女中站":["Wufu 3rd Road, Qianjin District, Kaohsiung City, 801", "Kaohsiung Girls' Senior High School", "Qianjin Dist."],
            "七賢忠孝站":["No. 415-441, Qixian 1st Road, Xinxing District, Kaohsiung City, 800", "Qixian-Zhongxiao", "Xinxing Dist."],
            "民生圓環站":["Zhongshan 1st Road, Xinxing District, Kaohsiung City, 800", "Minsheng Roundabout", "Xinxing Dist."],
            "民生民權站":["Lingya District, Kaohsiung City, 802", "Minsheng Mingcheng", "Lingya Dist."],
            "市府四維站":["Siwei 3rd Road, Lingya District, Kaohsiung City, 802", "Sihwei Administration Center", "Lingya Dist."],
            "文化師大站":["Heping 1st Road, Lingya District, Kaohsiung City, 802", "Scultural Normal Station", "Lingya Dist."],
            "新光成功站":["Chenggong 2nd Road, Lingya District, Kaohsiung City, 806", "Singuang Zhengkong", "Lingya Dist."],
            "民權公園站":["Minsheng 1st Rd, Xinxing District, Kaohsiung City, 800", "Minquan Park", "Xinxing Dist."],
            "光華公園站":["Minyu Street, Qianzhen District, Kaohsiung City, 806", "Guanghua Park", "Qianzhen Dist."],
            "家樂福成功站":["Zhonghua 5th Road, Qianzhen District, Kaohsiung City, 806", "Carrefour Chenggong Store", "Qianzhen Dist."],
            "夢時代站":["No. 119, Kaisyuan 4th Road, Qianzhen District, Kaohsiung City, 806", "Dream Mall", "Qianzhen Dist."]
            }
        #===================== CBike END =============
        
        if key == "PBike_PD":
            self.districtens = {
                "Pingtung City":"屏東市"
            }
            
            self.adsnEns = {
                "屏東火車站(唐榮國小站)":["Zhongshan Road & Yongfu Road, Pingtung City, Pingtung County, 900 (On the left entrance of Tangrong Elementary School)", "Tangrong Elementary School", "Pingtung City"],
                
                "勞工育樂中心站":["No. 17, Ziyou Road, Pingtung City, Pingtung County, 900 (Across from the Pingtung County Government Labor Affairs Bureau)", "Labor Recreation Center", "Pingtung City"],
                
                "屏東市公所站":["No. 3, Taitang Street, Pingtung City, Pingtung County, 900 (Across from Taisugar Warehouse Store)", "Pingtung County Pingtung City Office", "Pingtung City"],
                
                "屏東觀光夜市站":[" Minzu Road & Ren'ai Road, Pingtung City, Pingtung County, 900", "Pingtung Night Market", "Pingtung City"],
                
                "屏東大學屏商站":["No. 51, Minsheng East Road, Pingtung City, Pingtung County, 900 (Across from the University's Left Sidewalk)", "National Pingtung University Pingshang Campus", "Pingtung City"],
                
                "美術館站":["Gongyuan Road & Zhongsheng Road, Pingtung City, Pingtung County, 900 (On the side Gongyuan Road)", "Pingtung Art Museum", "Pingtung City"],
                
                "屏東女中站":[" Ren'ai Road, Pingtung City, Pingtung County, 900 (Scooter Parking Lot in Zhongsheng Park)", "Pingtung Girls’ High School", "Pingtung City"],
                
                "文化處站":["Provincial Highway 24 & Dalian Road, Pingtung City, Pingtung County, 900 (Coconut Parkway in Qianxi Park aka Millennium Park)", "Cultural Affairs Bureau of Pingtung County", "Pingtung City"],
                
                "環保局站":["No. 271, Ziyou Road, Pingtung City, Pingtung County, 900 (In front of Environmental Protection Bureau's right Parking Lot)", "Environmental Protection Bureau", "Pingtung City"],
                
                "屏東大學林森站":["Linsen Road & Minjiao Road, Pingtung City, Pingtung County, 900 (Close to Minjiao Rd.)", "National Pingtung University, Linsen Campus", "Pingtung City"],
                
                "演藝廳站":["Ruimin Road & Minsheng Road, Pingtung City, Pingtung County, 900 (Close to Minsheng Rd.)", "Pingtung Performing Arts Center", "Pingtung City"],
                
                "玉皇宮站":["No. 160, Zili Road, Pingtung City, Pingtung County, 900", "Yu-Huang Temple aka Temple of Emperor the Chinese Gods", "Pingtung City"],
                
                "將軍之屋站":["No. 108, Qingdao Street, Pingtung City, Pingtung County, 900 (Near DuoBoaWu Front Plaza on Qingdao Street)", "General House", "Pingtung City"],
                
                "縣政府站":["No. 527, Ziyou Road, Pingtung City, Pingtung County, 900 (Across Pingtung County Government Building Entrance's Left Sidewalk)", "Pingtung County Government Building", "Pingtung City"],
                
                "棒球場站":["Bangqiu Road & Xing'an Road, Pingtung City, Pingtung County, 900 (Close to Bangqiu Rd.)", "Pingtung Baseball Field", "Pingtung City"],
                
                "社會福利館站":["No. 184, Huazheng Road, Pingtung City, Pingtung County, 900 (Across from HePing Park", "Social Welfare Hall", "Pingtung City"],
                
                "中正藝術館站":["No. 427, Heping Road, Pingtung City, Pingtung County, 900 (Across from Chung Cheng Arts Hall)", "Zhong Cheng Arts Hall", "Pingtung City"],
                
                "崇蘭環保公園站":["Bo'ai Road & Chongde Road, Pingtung City, Pingtung County, 900 (Sidewalk on Bo'ai Rd.)", "Chongde Lan Eco-Friendly Park", "Pingtung City"],
                
                "崇大新城站":["Huasheng Street & Yonda Road, Pingtung City, Pingtung County, 900 (Near Yongda Rd.)", "Chong Da Shin Cheng", "Pingtung City"],
                
                "忠孝國小站":["No. 204, Jianfeng Road, Pingtung City, Pingtung County, 900 (Across from the Right Side of Zhongxiao Elementary School Entrance)", "Zhongxiao Elementary Schoool", "Pingtung City"],
                
                "環球購物中心站":["No. 90, Gongyuan Road & Ren'ai Road, Pingtung City, Pingtung County, 900 (Near Gongyuan Rd.)", "Global Mall", "Pingtung City"],
                
                "屏東高中站":["No. 860, Guangdong Road & Zhongxiao Road, Pingtung City, Pingtung County, 900 (Near Guangdong Rd.)", "Pingtung High School", "Pingtung City"],
                
                "屏東大學民生站":["No. 4-18, Minsheng Road, Pingtung City, Pingtung County, 900 (Minsheng Campus)", "National Pingtung University Minsheng Campus", "Pingtung City"],
                
                "千禧公園站":["Guangdong Road & Lane 456, Guangdong Road, Pingtung City, Pingtung County, 900", "Qianxi Park aka Millennium Park", "Pingtung City"],
                
                "屏東火車站(唐榮國小站)2":["No. 41, Zhongshan Road, Pingtung City, Pingtung County, 900 (On the Right Side of Tangrong Elementary School Entrance)", "Pingtung Train Station (Tangrong Elementary School)2", "Pingtung City"],
                
                "東山河站":["No. 526, Jichang North Road & Chongsheng 1st Street, Pingtung City, Pingtung County, 900 (Near Jichang N. Rd.)", "Dong Shan He", "Pingtung City"],
                
                "屏東書院站(孔廟)":["No. 38, Shengli Road, Pingtung City, Pingtung County, 900 (Shengli Rd. & Zhonghua Rd.)", "Pingtung College (Confucius Temple)", "Pingtung City"],
                
                "明正國中站":["Ren'ai Road & Gongqin Street, Pingtung City, Pingtung County, 900 (Near Ren'ai Rd.)", "Mingzheng Junior High School", "Pingtung City"],
                
                "國稅局站":["No. 55, Beixing Street, Pingtung City, Pingtung County, 900 (Across from the Left of Ministry of Finance)", "Ministry of Finance", "Pingtung City"],
                
                "中正國中站":["Section 2, Ruiguang Road & Tianliao Alley, Pingtung City, Pingtung County, 900 (Near Ruiguang Rd.)", "Zhongzheng Junior High School", "Pingtung City"]
            }
            
            
            