//
//  WeatherView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/9.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "WeatherView.h"

typedef enum : NSUInteger {
    UpperRight,
    UpperLeft,
    LowerRight,
    LowerLeft,
} WeatherButtonRelativeLocation;


@implementation WeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
               isUserLocation:(BOOL) isUserLocation
     withWeatherButtonLocated:(WeatherButtonRelativeLocation) buttonLocation
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupCommonUI {
    
}

- (void)setupButtonUI {
    
}


- (void)newLocationDetected:(NSString *)locality AdminArea:(NSString *)adminArea {
    NSDictionary * json = [NSDictionary getJSONFromMainBundle:@"AdminAreaLocality"];
    if (adminArea != nil && locality != nil)
    {
        NSString    *newAdminArea       = [adminArea lowercaseStringWithLocale:nil];
        NSString    *newLocality        = [locality lowercaseStringWithLocale:nil];
        
        NSDictionary    *detail         = json[newAdminArea];
        NSString        *dataID         = detail[@"dataid"];
        NSString        *localityName   = detail[@"locationNames"][newLocality];
        
//        [ServerConnector ]
    }
}



@end
