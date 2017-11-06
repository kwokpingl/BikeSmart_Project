//
//  BikeMarkers.h
//  BikeSmart
//
//  Created by Jimmy on 2017/8/9.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"

@interface BikeMarkers : NSObject

typedef enum : NSUInteger {
    CBike = 0,
    EBike,
    IBike,
    KBike,
    PBike,
    TBike,
    UBike
} BikeTypes;

typedef struct {
    int stnNO;
    
    __unsafe_unretained NSString * adCn;    // Chinese Address
    __unsafe_unretained NSString * saCn;    // Chinese Station Area
    __unsafe_unretained NSString * snCn;    // Chinese Station Name
    
    __unsafe_unretained NSString * adEn;    // English Address
    __unsafe_unretained NSString * saEn;    // English Station Area
    __unsafe_unretained NSString * snEn;    // English Station Name
    
    int tot;
    int bikes;
    int spaces;
    
    __unsafe_unretained NSDate * uDate;     // Last Updated Time
    
    float lat;
    float lng;
    
    bool act;                               // isActive? 0:false, 1: true
    
    __unsafe_unretained NSString * pic1;    // picture 1 url
    __unsafe_unretained NSString * pic2;    // picture 2 url
    
    __unsafe_unretained NSString * bike;    // Bike type
    
    BikeTypes type;                         // Types of Bikes
    
} BikeModel;



+(BikeModel) setBikeMarker:(NSDictionary *) data;

@end
