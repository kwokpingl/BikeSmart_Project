//
//  BikeMarkers.m
//  BikeSmart
//
//  Created by Jimmy on 2017/8/9.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeMarkers.h"

@implementation BikeMarkers

+ (BikeModel) setBikeMarker:(NSDictionary *) data {
    
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    BikeModel bike = {
        [data[bike_stnNO] intValue],
        data[bike_adCn],
        data[bike_saCn],
        data[bike_snCn],
        
        data[bike_adEn],
        data[bike_saEn],
        data[bike_snEn],
        
        [data[bike_tot] intValue],
        [data[bike_bikes] intValue],
        [data[bike_spaces] intValue],
        
        [dateFormat dateFromString:data[bike_uDate]],
        
        [data[bike_lat] floatValue],
        [data[bike_lng] floatValue],
        [data[bike_act] boolValue],
        
        data[bike_pic1],
        data[bike_pic2],
        
        data[bike_type],
        
        // Get BikeType
        [BikeMarkers getBikeTypeFromStr:data[bike_type]]
    };
    
    return bike;
}


+ (BikeTypes) getBikeTypeFromStr: (NSString *) type{
    
    BikeTypes bikeType;
    
    if ([type rangeOfString:@"CBike"
                    options:NSCaseInsensitiveSearch].location != NSNotFound) {
        bikeType = CBike;
    } else if ([type rangeOfString:@"EBike"
                           options:NSCaseInsensitiveSearch].location != NSNotFound) {
        bikeType = EBike;
    } else if ([type rangeOfString:@"IBike"
                           options:NSCaseInsensitiveSearch].location != NSNotFound) {
        bikeType = IBike;
    } else if ([type rangeOfString:@"KBike"
                           options:NSCaseInsensitiveSearch].location != NSNotFound) {
        bikeType = KBike;
    } else if ([type rangeOfString:@"PBike"
                           options:NSCaseInsensitiveSearch].location != NSNotFound) {
        bikeType = PBike;
    } else if ([type rangeOfString:@"TBike"
                           options:NSCaseInsensitiveSearch].location != NSNotFound) {
        bikeType = TBike;
    } else {
        bikeType = UBike;
    }
    
    return bikeType;
    
}


@end
