//
//  WeatherModel.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/11.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct WeatherModel {
    __unsafe_unretained NSString    *adminArea;
    __unsafe_unretained NSString    *locality;
    __unsafe_unretained NSDate      *startTime;
    __unsafe_unretained NSDate      *endTime;
    __unsafe_unretained NSNumber    *Wx;
    __unsafe_unretained NSString    *WxUnit;
    __unsafe_unretained NSNumber    *AT;
    __unsafe_unretained NSString    *ATUnit;
    __unsafe_unretained NSNumber    *T;
    __unsafe_unretained NSString    *TUnit;
    __unsafe_unretained NSNumber    *Pop;
    __unsafe_unretained NSNumber    *PopSix;
    __unsafe_unretained NSString    *PopUnit;
    __unsafe_unretained NSString    *PopSixUnit;
    __unsafe_unretained NSString    *CI;
    
} WeatherModel;
