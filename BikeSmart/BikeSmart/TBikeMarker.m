//
//  TBikeMarker.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/11.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "TBikeMarker.h"
/*
 T-Bike 臺南市公共自行車租賃站資訊 (JSON)
 http://tbike.tainan.gov.tw:8081/Service/StationStatus/Json
 
 Id(編號)、StationName(站名)、Address(地址)、Capacity(格位數)、AvaliableBikeCount(可借車輛數)、AvaliableSpaceCount(可停空位數)、UpdateTime(更新時間)、Latitude(緯度)、Longitude(經度)
 
 [
 {
 "$id": "1",
 "Id": 3,
 "StationName": "保安轉運站",
 "Address": "保安轉運站公車侯車亭旁 (文賢路一段)",
 "Capacity": 32,
 "AvaliableBikeCount": 11,
 "AvaliableSpaceCount": 21,
 "UpdateTime": "2017-07-11T07:46:24.147",
 "Latitude": 22.932706,
 "Longitude": 120.230637
 }]
 
 */
@implementation TBikeMarker

@end
