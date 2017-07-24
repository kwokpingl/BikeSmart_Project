//
//  YouBikeMarker.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/10.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "YouBikeMarker.h"

/*
 NTC // 新北
 http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000352-001
 JSON:
 @[@"success":true, @"result":@[@"fields":@[@"type":@"text", @"id":@"sno"],
                                @"records":@[@"sno":@"1002",...]]]
 
 API 
 sno:站點代號、sna:場站名稱(中文)、tot:場站總停車格、sbi:可借車位數、sarea:場站區域(中文)、mday:資料更新時間、lat:緯度、lng:經度、ar:地址(中文)、sareaen:場站區域(英文)、snaen:場站名稱(英文):aren、地址(英文):bemp:可還空位數、act:場站是否暫停營運
 
 TC // 台北
 
 
 SinChu // 新竹
 http://opendata.hccg.gov.tw/dataset/29f955d2-d712-4a23-9dc2-616bf3e5cb98/resource/3a994702-a44c-47cb-babb-7740f4dac009/download/20170609112726999.json
 // 使用率
 http://opendata.hccg.gov.tw/dataset/04deb611-d30b-4383-90ac-0245a61d5bc6/resource/f8b99d23-f1f6-4a13-bd4b-54df59859117/download/20170622094908273.json
 
 TaoYun // 桃園
 
 TaiChun // 台中 iBike
 
 
 ChangHua
 
 YunLin // Not available
 http://data.gov.tw/node/40464
 */


enum Location {
    NewTC,  // New Taipei City
    SinChu, // SinChuCity
    
};


@implementation YouBikeMarker

@end
