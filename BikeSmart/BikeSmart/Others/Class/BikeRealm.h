//
//  BikeRealm.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/13.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

static NSString * BikePrimaryKey = @"stnNO";

@interface BikeRealm : RLMObject

@property NSNumber<RLMInt>      *stnNO; // Station Number Primary Key
@property NSString              *type;
@property NSString              *snCn;  // Station Name
@property NSString              *snEn;
@property NSString              *adCn;  // Station Address
@property NSString              *adEn;
@property NSString              *saCn;  // Station Area
@property NSString              *saEn;
@property NSNumber<RLMDouble>   *lng;
@property NSNumber<RLMDouble>   *lat;
@property NSNumber<RLMBool>     *act;
@property NSNumber<RLMInt>      *bikes;
@property NSNumber<RLMInt>      *spaces;
@property NSNumber<RLMInt>      *tot;

@property NSString              *pic1;
@property NSString              *pic2;

@property NSDate                *uDate; // Update Date

@property NSNumber<RLMBool>     *isFavorite; 
@end


@implementation BikeRealm

+ (NSString *)primaryKey
{
    return BikePrimaryKey;
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"isFavorite":@(false)};
}

@end
// 'UBike_NTP', 'UBike_TY', 'TBike_TN', 'CBike_KS', 'IBike_HCC', 'UBike_HC', 'EBike_CY', 'UBike_CH', 'PBike_PD', 'KBike_KM'
@interface UBikeNTP : BikeRealm

@end

@implementation UBikeNTP

@end

@interface UBikeTY : BikeRealm

@end

@implementation UBikeTY

@end

@interface UBikeHC : BikeRealm

@end

@implementation UBikeHC

@end

@interface UBikeCH : BikeRealm

@end

@implementation UBikeCH

@end

@interface UBikeTP : BikeRealm

@end

@implementation UBikeTP

@end

@interface TBikeTN : BikeRealm

@end

@implementation TBikeTN

@end

@interface CBikeKS : BikeRealm

@end

@implementation CBikeKS

@end

@interface IBikeTC : BikeRealm

@end

@implementation IBikeTC

@end

@interface EBikeCY : BikeRealm

@end

@implementation EBikeCY

@end

@interface PBikePD : BikeRealm

@end

@implementation PBikePD

@end

@interface KBikeKM : BikeRealm

@end

@implementation KBikeKM

@end
