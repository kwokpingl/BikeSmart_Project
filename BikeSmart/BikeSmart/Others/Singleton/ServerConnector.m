//
//  ServerConnector.m
//  BikeSmart
//
//  Created by Jimmy on 2017/9/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "ServerConnector.h"
#import "Constants.h"

@implementation ServerConnector

+(instancetype)sharedInstance {
    static ServerConnector * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ServerConnector alloc] init];
    });
    
    return instance;
}

- (void)fetchData:(BikeTypes)bikeType completeHandler:(bikeDataHandler) dataHandler {
    
    NSString * bike = @"";
    
    switch (bikeType) {
        case CBike_KS:
            bike = @"CBike_KS";
            break;
        case EBike_CY:
            bike = @"EBike_CY";
            break;
        case IBike_TC:
            bike = @"IBike_TC";
            break;
        case KBike_KM:
            bike = @"KBike_KM";
            break;
        case PBike_PD:
            bike = @"PBike_PD";
            break;
        case TBike_TN:
            bike = @"TBike_TN";
            break;
        case UBike_CH:
            bike = @"UBike_CH";
            break;
        case UBike_HC:
            bike = @"UBike_HC";
            break;
        case UBike_NTP:
            bike = @"UBike_NTP";
            break;
        case UBike_TY:
            bike = @"UBike_TY";
            break;
        case UBike_TP:
            bike = @"UBike_TP";
            break;
    }
    
    // PREPARE DATA for PHP
    NSDictionary    * param = @{SBAPIKey_Data:@{SBAPIKey_Type:bike}};
    NSError         * error = nil;
    NSData          * data  = [NSJSONSerialization dataWithJSONObject:param
                                                              options:NSJSONWritingPrettyPrinted error:&error];
    
    // PREPARE URLSESSION CONFIG.
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Content-Type"  :
                                         @"application/json; charset=UTF-8"};
    
    // PREPARE URLSESSION
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    
    NSURL * url = [[NSURL alloc] initWithString:SmartBikerURL];
    
    // PREPARE URLREQUEST
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    
    // PREPARE SESSION DATA TASK
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            dataHandler(nil, error, nil, false);
            return;
        }
        
        NSError * serializedError = nil;
        
        if (data == nil)
        {
            dataHandler(nil, nil, nil, false);
            return;
        }
        
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializedError];
        
        
        dataHandler(jsonData, nil, serializedError, true);
        
//         NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [task resume];
    
    [session finishTasksAndInvalidate];
}

- (void) fetchBikeData:(NSArray *)bikeTypes completeHandler:(bikeDataHandler)dataHandler
{
    // Prepare data
    NSArray *bikeTypeStrs = [NSArray new];
    
    bikeTypeStrs = [BikeModel bikeTypesToStringArrayConverter:bikeTypes];
    
    NSDictionary    *param  = @{SBAPIKey_Data:@{SBAPIKey_Type: bikeTypeStrs}};
    NSError         *error  = nil;
    NSData          *data   = [NSJSONSerialization dataWithJSONObject:param
                                                              options:NSJSONWritingPrettyPrinted
                                                                error:&error];
    if (error != nil)
    {
        NSAssert(error != nil ,@"Error at %s : \n %@", __FUNCTION__, [error description]);
        return;
    }
    
    
    // Setup Session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Content-Type"  : @"application/json; charset=UTF-8"
                                     };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURL *url = [NSURL URLWithString:SmartBikerURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil)
        {
            dataHandler(nil, error, nil, false);
            return;
        }
        
        if (data == nil)
        {
            dataHandler(nil, nil, nil, false);
            return;
        }
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&jsonError];
        
        if (jsonError != nil)
        {
            dataHandler(nil, nil,jsonError, false);
            return;
        }
        
        dataHandler(jsonData, nil, jsonError, true);
    }];
    
    [task resume];
    
    // FIX Memory Leak
    [session finishTasksAndInvalidate];
}


/**
 Connect to https://opendata.cwb.gov.tw/ to fetch Local Weather Forecast

 @param dictionary {@"dataid":@"F-D0047-001",
                    @"locationName":@"頭城鎮",
                    @"elementName":@"Wx, PoP, AT, T, CI, WeatWeatWeatWeatherDescription, Pop6h, Wind",
                    @"sort":@"time",
                    @"timeFrom":@"2017-02-06T18:00:00",
                    @"timeTo":@"2017-02-06T18:00:00"}
 
 if use timeTo : @"2017-02-06T18:00:00, 2017-02-06T20:00:00" or dataTime : @"2017-02-06T18:00:00, 2017-02-06T20:00:00", then timeFrom / timeTo won't be considered
 
 Extra parameters:
 format : xml or json (default)
 */
- (void) fetchWeather:(NSDictionary *) dictionary {
    // https://opendata.cwb.gov.tw/api/v1/rest/datastore/{dataid}?locationName={locationName}&elementName={elementName}&sort={sort}&startTime={startTime}&dataTime={dataTime}&timeFrom={timeFrom}&timeTo={timeTo}&format={format = json}
    
    
}


@end
