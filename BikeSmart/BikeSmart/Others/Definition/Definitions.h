//
//  Definitions.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#ifndef Definitions_h
#define Definitions_h

#pragma mark - Block
/////////////////////////////////
//      GEO DECODER HANDLER
/////////////////////////////////

typedef void(^GeoDecoderHandler)(NSString * adminArea, NSString * locality);



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





#endif /* Definitions_h */
