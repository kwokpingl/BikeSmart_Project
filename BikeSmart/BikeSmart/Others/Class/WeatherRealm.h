//
//  WeatherRealm.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/12.
//  Copyright © 2017年 Jimmy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

//////////////////////////////////////////
//  WeatherRealm
/// a RLMObject that saves the needed Data from 中央氣象
/// including Wx, Pop, AT, T, CI, Wind and WeatherDescription
//////////////////////////////////////////

@interface WeatherRealm : RLMObject
@property NSString              *primaryKey;
@property NSDate                *startTime;
@property NSDate                *endTime;
@property NSString              *WxElementValue;            // 天氣圖示代碼+描述 ie 多雲
@property NSNumber<RLMInt>      *WxParameterValue;          //                    02
@property NSNumber<RLMDouble>   *PopElementValue;           // (Probability of Precipitation)
@property NSString              *PopElementMeasure;         // %
@property NSNumber<RLMDouble>   *PopSixHElementValue;       // (Probability of Precipitation in 6 Hour)
@property NSString              *PopSixHElementMeasure;     // %
@property NSNumber<RLMDouble>   *ATElementValue;            // (Apparent Temperature)
@property NSString              *ATElementMeasure;          // C
@property NSNumber<RLMDouble>   *TElementValue;
@property NSString              *TElementMEasure;           // C
@property NSString              *CIParameterValue;          // 體感舒適度
@property NSString              *WindParameterEnValue;      // NE
@property NSString              *WindParameterZhValue;      // 東北方
@property NSString              *WindParameterSpeed;        // < 1
@property NSString              *WindParameterSpeedUnit;    // m/s
@property NSString              *WeatherDescription;        // WeatherDescription
@end


RLM_ARRAY_TYPE(WeatherRealm)

//////////////////////////////////////////
//      LocationRealm
/// @p adminLocalityEn  : Adminstrative Area + " " + Locality in English (Primary Key)
/// @p weatherDetails   : Wether RLMObject that saves all the info required with StartTime as PrimaryKey
//////////////////////////////////////////

@interface LocationRealm : RLMObject
@property NSString              *adminLocalityEn;
@property NSString              *adminAreaZh;
@property NSString              *adminAreaEn;
@property NSString              *localityZh;
@property NSString              *localityEn;
@property NSString              *geoCode;
@property RLMArray<WeatherRealm *><WeatherRealm>    *weatherDetails;
@end

//
//  WeatherRealm.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/12.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "WeatherRealm.h"

// 鄉鎮天氣預報 鄉鎮天氣預報 -單一鄉鎮市區預報資料 單一鄉鎮市區預報資料 (未來 2天氣預報 天氣預報 )

static NSString                 *WeatherPrimaryKey      = @"primaryKey";
static NSString                 *LocationPrimaryKey     = @"adminLocalityEn";


@implementation WeatherRealm

+(NSArray<NSString *> *)requiredProperties {
    return @[WeatherPrimaryKey];
}

@end

//////////////////////////////////////////
//
//////////////////////////////////////////


@implementation LocationRealm

+(NSArray<NSString *> *)requiredProperties
{
    return @[LocationPrimaryKey, @"localityEn", @"adminAreaEn"];
}

+ (NSString *)primaryKey
{
    return LocationPrimaryKey;
}

- (NSString *)locationZh
{
    return [NSString stringWithFormat:@"%@, %@", self.adminAreaZh, self.localityZh];
}

- (NSString *)locationEn
{
    return [NSString stringWithFormat:@"%@, %@", self.localityEn, self.adminAreaEn];
}

- (void)updatePrimaryKey
{
    self.adminLocalityEn = [NSString stringWithFormat:@"%@_%@", self.localityEn, self.adminAreaEn];
}


@end
