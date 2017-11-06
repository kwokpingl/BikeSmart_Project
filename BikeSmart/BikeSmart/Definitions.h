//
//  Definitions.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#ifndef Definitions_h
#define Definitions_h

#define GoogleAPIKey @"AIzaSyCr1qmNgwx4-GjvL6dJyqz7ETJf2bChSuI"

typedef enum Cities:NSUInteger {
    NewTaipei = 1,
    Taipei,
    Taoyuan,
    Hsinchu,
    HsinchuCounty,  // 愛心
    Taichung,       // iBike
    Changhua,
    Chiayi,         // eBike
    Tainan,         // T-Bike
    Kaohsiung,      // CityBike
    Pingtung,       // P-Bike
    Kinmen,         // K-Bike
    OBike           // O-Bike
} cities;

/*
 The solution below uses the preprocessor's stringize operator, allowing for a more elegant solution. It lets you define the enum terms in just one place for greater resilience against typos.
 */
#define ENUM_ICON \
X(Bike),    \
X(BikeBlack),   \
X(YouBike), \
X(CityBike), \
X(MenuBg),   \
X(MenuBgAlter)  \

#define X(a)    a
typedef enum Icon {
    ENUM_ICON
} selectedIcon;
#undef X

#define bike_stnNO  @"stnNO"

#define bike_adCn   @"adCn"
#define bike_saCn   @"saCn"
#define bike_snCn   @"snCn"

#define bike_adEn   @"adEn"
#define bike_saEn   @"saEn"
#define bike_snEn   @"snEn"

#define bike_tot    @"tot"
#define bike_bikes  @"bikes"
#define bike_spaces @"spaces"

#define bike_uDate  @"uDate"

#define bike_lat    @"lat"
#define bike_lng    @"lng"

#define bike_act    @"act"

#define bike_pic1   @"pic1"
#define bike_pic2   @"pic2"

#define bike_type   @"type"


#endif /* Definitions_h */
