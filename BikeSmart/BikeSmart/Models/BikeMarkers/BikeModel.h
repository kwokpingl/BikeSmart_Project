//
//  BikeModel.h
//  BikeSmart
//
//  Created by Jimmy on 2017/9/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>

#import "RealmUtil.h"
#import "UIColor+JLColor.h"
//@class BikeModel;
/*
 stnNo  : Station Number
 adCn   : Address Chinese
 snCn   : Station Name Chinese
 saCn   : Station Area Chinese
 
 adEn
 snEn
 saEn
 
 tot    : Total Space
 bikes  : Total Bike Avaliable
 spaces : Total Empty Space
 
 uDate  : Updated Date
 
 lat    : Latitude
 lng    : Longitude
 
 act    : 1(active) 0(inactive)
 
 pic1
 pic2
 
 type   : Bike Types
 */

typedef enum : NSUInteger {
    CBike_KS = 1,   // 高雄
    EBike_CY,       // 嘉義
    IBike_TC,       // Taichung
    KBike_KM,       // Kinmen
    PBike_PD,       // 屏東
    TBike_TN,       // Tainan
    UBike_CH,       // 彰化 ... 無
    UBike_HC,       // 新竹 ... 無
    UBike_NTP,      // New Taipei
    UBike_TY,       // TaoYuan
    UBike_TP,       // Taipei
} BikeTypes;

typedef enum : NSUInteger {
    En = 1,
    Zh
} DisplayLanguage;

@interface BikeModel : NSObject

@property (nonatomic, getter=isFavorite, setter=setFavorite:) BOOL isFavorite;

+ (NSArray *) bikeTypesToStringArrayConverter:(NSArray *) bikeEnumInts;

- (instancetype)init:(NSDictionary *) bikeData for:(BikeTypes) bikeType;
- (int) getStationNumber;
- (int) getBikeNumber;
- (int) getSpaceNumber;
- (int) getTotalSpaces;
- (BikeTypes) getBikeType;
- (NSString *) getImageName;
- (NSString *) getUpdatedDate;
- (CLLocation *) getCoordinate;
- (NSString *) getAddress;
- (NSString *) getStationName;
- (NSString *) getStationArea;
- (NSString *) getStationDistrict;
- (NSArray<NSURL *> *) getPicURLs;
- (NSString *) getUniqueKey;
- (NSString *) getBikeTypeString;
- (NSDictionary *) bikeModelParser;

- (UIColor *) getPrimaryColor;
- (UIColor *) getSecondaryColor;
- (UIColor *) getTertiaryColor;


@end

