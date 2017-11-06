# -*- coding: utf-8 -*- 
from __future__ import print_function
#__future__ is a real module, and serves three purposes:
#
#To avoid confusing existing tools that analyze import statements and expect to find the modules they're importing.
#To ensure that future statements run under releases prior to 2.1 at least yield runtime exceptions (the import of __future__ will fail, because there was no module of that name prior to 2.1).
#To document when incompatible changes were introduced, and when they will be - or were - made mandatory. This is a form of executable documentation, and can be inspected programmatically via importing __future__ and examining its contents.
import sys
reload(sys)
sys.setdefaultencoding('utf-8')


from UBikeJSON_Decoder import UBikeJSON_Decoder
from XML_Decoder import XML_Decoder
from WebSite_Decoder import WebSite_Decoder
#from TBCreator import TBCreator
#from JSONDecoder import JSONDecoder
# 加上面一句才可以用中文註解

# setup html pages
#============ json ===============
# 新北
NTP_UBike = 'http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000352-001'
# 桃園
TY_UBike  = 'http://data.tycg.gov.tw/api/v1/rest/datastore/a1b4714b-3b75-4ff8-a8f2-cc377e4eaa0f?format=json'
# 新竹市
HC_M    = 'http://data.gov.tw/node/gov/resource/90713'
HC_Location = 'http://opendata.hccg.gov.tw/dataset/29f955d2-d712-4a23-9dc2-616bf3e5cb98/resource/3a994702-a44c-47cb-babb-7740f4dac009/download/20170609112726999.json'
# 台南
TN_TBike  = 'http://tbike.tainan.gov.tw:8081/Service/StationStatus/Json'

# ============== xml =======================
# 高雄
KS_CBike  = 'http://www.c-bike.com.tw/xml/stationlistopendata.aspx'
# 屏東
PD_PBike    = 'http://pbike.pthg.gov.tw/xml/stationlist.aspx'

# ============== gz ========================
# 台北
TP_UBike  = 'http://data.taipei/youbike' #gz

# =============== webSites =================
# 新竹縣
HCC_IBike   = 'http://i.youbike.com.tw/cht/f12.php'
HCC_IBikeE  = 'http://i.youbike.com.tw/en/f12.php'
# 嘉義
CY_EBike    = 'http://ebike.citypower.com.tw/station_list.php'
# 彰化
CH_UBike    = 'http://chcg.youbike.com.tw/cht/f12.php'
CH_UBikeE   = 'http://chcg.youbike.com.tw/en/f12.php'
# 金門 => need coordinate
# MAP => http://kbike.yachik.com/kbike_web/station.php 
#KM_KBike    = 'http://kbike.yachik.com/kbike_web/station_list.php'
KM_KBike    = 'http://kbike.yachik.com/recv/show_kbike_bike_info.php'
# 新竹市
HC_UBike    = 'http://hccg.youbike.com.tw/cht/f12.php'
HC_UBikeE   = 'http://hccg.youbike.com.tw/en/f12.php'
# GET the CORRECT SITES


# ============== RULES =======================
TP_Rules    = ["https://taipei.youbike.com.tw/cht/f43.php",
              "https://taipei.youbike.com.tw/en/f43.php"]

HCC_Rules   = ["http://i.youbike.com.tw/cht/f43.php",
               "http://i.youbike.com.tw/en/f43.php"]

PD_Rules    = ["http://pbike.pthg.gov.tw/Station/Explanation.aspx",
 "http://pbike.pthg.gov.tw/Station/ExplanationEn.aspx"]



DB_NAME = 'BikeSmart'
USER    = 'root'
PWD     = 'root'
HOST    = 'localhost'
ftp     = False


if ftp:
    USER    = 'jimmy-maltose@jimmy-maltose.appjam.space'
    PWD     = 'LiuKuoPing@1129'
    HOST    = 'ftp.appjam.space'
    
print(USER)

Bike_Tables = ['UBike_NTP', 'UBike_TY', 'TBike_TN', 'CBike_KS', 'IBike_HCC', 'UBike_HC', 'EBike_CY', 'UBike_CH', 'PBike_PD', 'KBike_KM']

jsonURLs    = {'UBike_NTP': NTP_UBike, 
               'UBike_TY':  TY_UBike}
jsonTBike   = {'TBike_TN':  TN_TBike}
xmlURLs     = {'CBike_KS':  KS_CBike,
               'PBike_PD':  PD_PBike}
webSites    = {'IBike_HCC': [HCC_IBike, HCC_IBikeE],
               'EBike_CY':  [CY_EBike], 
               'UBike_HC':  [HC_UBike, HC_UBikeE],
               'UBike_CH':  [CH_UBike, CH_UBikeE],
               'KBike_KM':  [KM_KBike]}

# CREATE UBike Decoder
statement = " stnNO         INT(4)          NOT NULL," + \
    " adCn          VARCHAR(255)    NOT NULL," + \
    " snCn          VARCHAR(255)    NOT NULL," + \
    " saCn          VARCHAR(255)    ," + \
    " adEn          VARCHAR(255)    ," + \
    " snEn          VARCHAR(255)    ," + \
    " saEn          VARCHAR(255)    ," + \
    " tot           INT             NOT NULL," + \
    " bikes         INT             NOT NULL," + \
    " spaces        INT             NOT NULL," + \
    " uDate         DATETIME        NOT NULL," + \
    " lat           DECIMAL(9,6)    NOT NULL," + \
    " lng           DECIMAL(9,6)    NOT NULL," + \
    " act           TINYINT         NOT NULL," + \
    " pic1          VARCHAR(255)    ," + \
    " pic2          VARCHAR(255)    ," + \
    " type          VARCHAR(255)    ," + \
    " PRIMARY KEY(stnNO)"

ubikeDe = UBikeJSON_Decoder(DB_NAME, USER, PWD, HOST)
ubikeDe.setupURLsDic(jsonURLs)
ubikeDe.createTB(statement)
ubikeDe.fetchUBikeJSONData()

# CREATE TBike Decoder
tbikeDe = UBikeJSON_Decoder(DB_NAME, USER, PWD, HOST)
tbikeDe.setupURLsDic(jsonTBike)
tbikeDe.createTB(statement)
tbikeDe.fetchTBikeJSONData()

# CREATE CBike Decoder
cbikeDe = XML_Decoder(DB_NAME, USER, PWD, HOST)
cbikeDe.setupURLsDic(xmlURLs)
cbikeDe.createTB(statement)
cbikeDe.fetchCBikeXMLData()

webDe = WebSite_Decoder(DB_NAME, USER, PWD, HOST)
webDe.setupURLsDic(webSites)
webDe.createTB(statement)
webDe.fetchWebData()
    

