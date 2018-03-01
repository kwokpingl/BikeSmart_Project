//
//  RealmFactory.m
//  BikeSmart
//
//  This class is to connect Server with DataBase
//  Also, to allow other VC to fetch Data from DataBase
//
//  The classes involved in Connecting Database with Server are (in proceeding order)
//  1. + (void) updateBikeRealmsWithDictionary:(NSDictionary *) updateHandler:(RealmUpdated)
//          + (BikeTypes) returnBikeTypeEnum:(NSString *) type
//  2. + (void) recordBikeData:(NSDictionary *) forType:(BikeTypes) withUpdateHandler:(RealmUpdated)
//  3. + (void) setupBikeRealm:(BikeTypes) withDictionary:(NSDictionary *) withUpdateHandler:(RealmUpdated)
//  4. + (void) writeBikeRealm:(id) withBikeType:(BikeTypes) bikeData:(NSDictionary *)
//              andUpdateHandler:(RealmUpdated)
//
//
//
//  The classes involved in Getting Data from Realm are (in proceeding order)

//  Created by Jimmy on 2017/10/13.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "RealmUtil.h"
#import "BikeRealm.h"
#import "Constants.h"

static int totalDownloadData    = 0;
static int downloadDataCounter  = 0;
static int totalDownloadQuery   = 0;
static int downloadQueryCounter = 0;

static int counter = 0;

//static int totalFetchData       = 0;
//static int fetchDataCounter     = 0;
//static int totalFetchQuery      = 0;
//static int fetchQueryCounter    = 0;

@implementation RealmUtil

#pragma mark - UPDATE REALM of BIKE with DATA from SERVER
+ (void) updateBikeRealmsWithDictionary:(NSDictionary *)dataDictionary
                          updateHandler:(RealmUpdated)updateHandler
{
    totalDownloadData = (int)dataDictionary.allKeys.count;
    
    downloadDataCounter = 0;
    
    for (NSString * key in dataDictionary.allKeys)
    {
        
        NSArray * dataArray = dataDictionary[key];
        BikeTypes bikeType  = [self returnBikeTypeEnum:key];
        
        downloadDataCounter += 1;
        downloadQueryCounter = 0;
        for (NSDictionary * stationData in dataArray)
        {
            
            totalDownloadQuery = (int)dataArray.count;
            downloadQueryCounter += 1;
            
            [self recordBikeData:stationData forType:bikeType withUpdateHandler:updateHandler];
        }
        
    }
}

//////////////////////////////////////////////////////////
//      Fetch Data From REALM
//////////////////////////////////////////////////////////
#pragma mark - FETCH Data from Realm
+ (void) getSelectedBikeRealm:(RealmFetched)dataFetchHandler {
    NSArray <NSNumber *> *bikeTypes = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_BikeType];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
    
    for (NSNumber *bikeTypeRaw in bikeTypes)
    {
        BikeTypes bikeType = (BikeTypes) bikeTypeRaw.intValue;
        
        RLMResults *bikeResults = nil;
        
        switch (bikeType) {
            case UBike_NTP:
            {
                bikeResults = [UBikeNTP allObjects];
            }
                break;
            case UBike_TY:
            {
                bikeResults = [UBikeTY allObjects];
            }
                break;
            case UBike_HC:
            {
                bikeResults = [UBikeHC allObjects];
            }
                break;
            case UBike_CH:
            {
                bikeResults = [UBikeCH allObjects];
            }
                break;
            case UBike_TP:
            {
                bikeResults = [UBikeTP allObjects];
            }
                break;
            case IBike_TC:
            {
                bikeResults = [IBikeTC allObjects];
            }
                break;
            case TBike_TN:
            {
                bikeResults = [TBikeTN allObjects];
            }
                break;
            case CBike_KS:
            {
                bikeResults = [CBikeKS allObjects];
            }
                break;
            case EBike_CY:
            {
                bikeResults = [EBikeCY allObjects];
            }
                break;
            case PBike_PD:
            {
                bikeResults = [PBikePD allObjects];
            }
                break;
            case KBike_KM:
            {
                bikeResults = [KBikeKM allObjects];
            }
                break;
        }
//        NSLog(@"Bike Results : %lu", (unsigned long)bikeResults.count);
        
        NSMutableArray <BikeModel *> *bikeArray = [NSMutableArray new];
        
        for (BikeRealm * bike in bikeResults){
                        
            NSDictionary * bikeData = @{SBDB_BikeType:bike.type,
                                        SBDB_StationNumber:bike.stnNO,
                                        SBDB_Status:bike.act,
                                        SBDB_Longitude:bike.lng,
                                        SBDB_Latitude:bike.lat,
                                        SBDB_MainPicture:(bike.pic1 ? bike.pic1 : @""),
                                        SBDB_AlternativePicture:(bike.pic2 ? bike.pic2 : @""),
                                        SBDB_ChineseAddress:bike.adCn,
                                        SBDB_EnglishAddress:bike.adEn,
                                        SBDB_ChineseArea:bike.saCn,
                                        SBDB_EnglishArea:bike.saEn,
                                        SBDB_ChineseStationName:bike.snCn,
                                        SBDB_EnglishStationName:bike.snEn,
                                        SBDB_NumberOfBikeAvaliable:bike.bikes,
                                        SBDB_NumberOfEmptySpaces:bike.spaces,
                                        SBDB_TotalParkingSpaces:bike.tot,
                                        SBDB_LastUpdatedDate:bike.uDate,
                                        SBDB_IsFavorite:bike.isFavorite};
            
            BikeModel *bikeModel = [[BikeModel alloc] init:bikeData for:bikeType];
            [bikeArray addObject:bikeModel];
        }
        
        if (bikeArray.count > 0){
            dataDictionary[bikeTypeRaw] = bikeArray;
        }
    } // end of for
    dataFetchHandler(dataDictionary);
}

+ (void) getBikeRealmAtLocation:(CLLocationCoordinate2D)location completeHandler:(RealmFetchedWithCoordinate)dataFetchHandler {
    NSArray <NSNumber *> *bikeTypes = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_BikeType];
    
//    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    
    CGFloat deltaLat = DELTA_LAT;
    CGFloat deltaLng = DELTA_LNG;
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
    
    CGFloat lat = location.latitude;
    CGFloat lng = location.longitude;
    
    CGFloat maxLat = lat + deltaLat; // ~11km
    CGFloat minLat = lat - deltaLat;
    
    CGFloat maxLng = lng + deltaLng;
    CGFloat minLng = lng - deltaLng;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"lat BETWEEN {%f, %f} AND lng BETWEEN {%f, %f}", minLat, maxLat, minLng, maxLng];
    
    
    NSLog(@"%@", pred.predicateFormat);
    
    for (NSNumber *bikeTypeRaw in bikeTypes)
    {
        BikeTypes bikeType = (BikeTypes) bikeTypeRaw.intValue;
        
        RLMResults *bikeResults = nil;
        
        switch (bikeType) {
            case UBike_NTP:
            {
                bikeResults = [UBikeNTP objectsWithPredicate:pred];
            }
                break;
            case UBike_TY:
            {
                bikeResults = [UBikeTY objectsWithPredicate:pred];
            }
                break;
            case UBike_HC:
            {
                bikeResults = [UBikeHC objectsWithPredicate:pred];
            }
                break;
            case UBike_CH:
            {
                bikeResults = [UBikeCH objectsWithPredicate:pred];
            }
                break;
            case UBike_TP:
            {
                bikeResults = [UBikeTP objectsWithPredicate:pred];
            }
                break;
            case IBike_TC:
            {
                bikeResults = [IBikeTC objectsWithPredicate:pred];
            }
                break;
            case TBike_TN:
            {
                bikeResults = [TBikeTN objectsWithPredicate:pred];
            }
                break;
            case CBike_KS:
            {
                bikeResults = [CBikeKS objectsWithPredicate:pred];
            }
                break;
            case EBike_CY:
            {
                bikeResults = [EBikeCY objectsWithPredicate:pred];
            }
                break;
            case PBike_PD:
            {
                bikeResults = [PBikePD objectsWithPredicate:pred];
            }
                break;
            case KBike_KM:
            {
                bikeResults = [KBikeKM objectsWithPredicate:pred];
            }
                break;
        }
        //        NSLog(@"Bike Results : %lu", (unsigned long)bikeResults.count);
        
        NSMutableArray <BikeModel *> *bikeArray = [NSMutableArray new];
        
        for (BikeRealm * bike in bikeResults){
            
            NSDictionary * bikeData = @{SBDB_BikeType:bike.type,
                                        SBDB_StationNumber:bike.stnNO,
                                        SBDB_Status:bike.act,
                                        SBDB_Longitude:bike.lng,
                                        SBDB_Latitude:bike.lat,
                                        SBDB_MainPicture:(bike.pic1 ? bike.pic1 : @""),
                                        SBDB_AlternativePicture:(bike.pic2 ? bike.pic2 : @""),
                                        SBDB_ChineseAddress:bike.adCn,
                                        SBDB_EnglishAddress:bike.adEn,
                                        SBDB_ChineseArea:bike.saCn,
                                        SBDB_EnglishArea:bike.saEn,
                                        SBDB_ChineseStationName:bike.snCn,
                                        SBDB_EnglishStationName:bike.snEn,
                                        SBDB_NumberOfBikeAvaliable:bike.bikes,
                                        SBDB_NumberOfEmptySpaces:bike.spaces,
                                        SBDB_TotalParkingSpaces:bike.tot,
                                        SBDB_LastUpdatedDate:bike.uDate,
                                        SBDB_IsFavorite:bike.isFavorite};
            
            BikeModel *bikeModel = [[BikeModel alloc] init:bikeData for:bikeType];
            [bikeArray addObject:bikeModel];
        }
        
        if (bikeArray.count > 0){
            dataDictionary[bikeTypeRaw] = bikeArray;
        }
    } // end of for
    dataFetchHandler(dataDictionary, location);
}


//////////////////////
// OTHER METHODS
//////////////////////
#pragma mark - Other Methods
#pragma mark : Record Bike Data after Fetching from Server
+ (void) recordBikeData:(NSDictionary *) dataDictionary
                forType:(BikeTypes) bikeType
      withUpdateHandler:(RealmUpdated)updateHandler
{
//    NSLog(@"%@", NSStringFromSelector(_cmd)); // Objective-C
//    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    
    counter += 1;
    
    
    NSString *type      = dataDictionary[SBDB_BikeType];
    
    if (type != (NSString *)[NSNull null]) {
        
        NSNumber *stnNO     = [NSNumber numberWithInteger:[dataDictionary[SBDB_StationNumber] integerValue]];
        NSNumber *isActive  = [NSNumber numberWithBool:[dataDictionary[SBDB_Status] boolValue]];
        NSNumber *lng       = [NSNumber numberWithDouble:[dataDictionary[SBDB_Longitude] doubleValue]];
        NSNumber *lat       = [NSNumber numberWithDouble:[dataDictionary[SBDB_Latitude] doubleValue]];
        
        NSString *pic1URL   = dataDictionary[SBDB_MainPicture];
        NSString *pic2URL   = dataDictionary[SBDB_AlternativePicture];
        
        NSString *adCn      = dataDictionary[SBDB_ChineseAddress];
        NSString *adEn      = dataDictionary[SBDB_EnglishAddress];
        NSString *saCn      = dataDictionary[SBDB_ChineseArea];
        NSString *saEn      = dataDictionary[SBDB_EnglishArea];
        NSString *snCn      = dataDictionary[SBDB_ChineseStationName];
        NSString *snEn      = dataDictionary[SBDB_EnglishStationName];
        
        NSNumber *bikes     = [NSNumber numberWithInt:[dataDictionary[SBDB_NumberOfBikeAvaliable] intValue]];
        NSNumber *spaces    = [NSNumber numberWithInt:[dataDictionary[SBDB_NumberOfEmptySpaces] intValue]];
        NSNumber *total     = [NSNumber numberWithInt:[dataDictionary[SBDB_TotalParkingSpaces] intValue]];
        
        NSDateFormatter * formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate  *uDate = [formatter dateFromString:dataDictionary[SBDB_LastUpdatedDate]];
        
        NSDictionary * bikeData = @{SBDB_BikeType:type, SBDB_StationNumber:stnNO, SBDB_Status:isActive, SBDB_Longitude:lng, SBDB_Latitude:lat, SBDB_MainPicture:pic1URL, SBDB_AlternativePicture:pic2URL, SBDB_ChineseAddress:adCn, SBDB_EnglishAddress:adEn, SBDB_ChineseArea:saCn, SBDB_EnglishArea:saEn, SBDB_ChineseStationName:snCn, SBDB_EnglishStationName:snEn, SBDB_NumberOfBikeAvaliable:bikes, SBDB_NumberOfEmptySpaces:spaces, SBDB_TotalParkingSpaces:total, SBDB_LastUpdatedDate:uDate};
        
//        NSLog(@"END of %s", __FUNCTION__);
        
        [self setupBikeRealm:bikeType withDictionary:bikeData withUpdateHandler:updateHandler];
    }
}

#pragma mark -Setup Bike Realm to write into Realm
+ (void)setupBikeRealm:(BikeTypes) bikeType
        withDictionary:(NSDictionary *) data
     withUpdateHandler:(RealmUpdated)updateHandler
{
    
//    NSLog(@"%@", NSStringFromSelector(_cmd)); // Objective-C
    switch (bikeType) {
        case UBike_NTP:
        {
            UBikeNTP * bike = [UBikeNTP new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case UBike_TY:
        {
            UBikeTY * bike = [UBikeTY new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case UBike_HC:
        {
            UBikeHC * bike = [UBikeHC new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case UBike_CH:
        {
            UBikeCH * bike = [UBikeCH new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case UBike_TP:
        {
            UBikeTP * bike = [UBikeTP new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case IBike_TC:
        {
            IBikeTC * bike = [IBikeTC new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case TBike_TN:
        {
            TBikeTN * bike = [TBikeTN new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case CBike_KS:
        {
            CBikeKS * bike = [CBikeKS new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case EBike_CY:
        {
            EBikeCY * bike = [EBikeCY new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case PBike_PD:
        {
            PBikePD * bike = [PBikePD new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
        case KBike_KM:
        {
            KBikeKM * bike = [KBikeKM new];
            [bike setValuesForKeysWithDictionary:data];
            [self writeBikeRealm:bike withBikeType:bikeType bikeData:data andUpdateHandler:updateHandler];
        }
            break;
    }
}

#pragma mark -Write Bike Data into Realm
+ (void)writeBikeRealm:(id)bikeRealm
          withBikeType:(BikeTypes) bikeType
              bikeData:(NSDictionary *) data
      andUpdateHandler:(RealmUpdated)updateHandler
{
//    NSLog(@"%@", NSStringFromSelector(_cmd)); // Objective-C
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:bikeRealm];
        updateHandler(downloadQueryCounter == totalDownloadQuery,
                      (int)((double)downloadDataCounter/(double)totalDownloadData * 100));
    }];
}

#pragma mark - UPDATE BIKE DATA from REALM
+ (void)updateBikeModel:(BikeModel *) bikeModel
       completeHandler:(RealmDataChanged) completeHandler{
    
    BikeTypes bikeType = [bikeModel getBikeType];
    NSDictionary *data = [bikeModel bikeModelParser];
    
    switch (bikeType) {
        case UBike_NTP:
        {
            UBikeNTP * bike = [UBikeNTP new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case UBike_TY:
        {
            UBikeTY * bike = [UBikeTY new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case UBike_HC:
        {
            UBikeHC * bike = [UBikeHC new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case UBike_CH:
        {
            UBikeCH * bike = [UBikeCH new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case UBike_TP:
        {
            UBikeTP * bike = [UBikeTP new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case IBike_TC:
        {
            IBikeTC * bike = [IBikeTC new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case TBike_TN:
        {
            TBikeTN * bike = [TBikeTN new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case CBike_KS:
        {
            CBikeKS * bike = [CBikeKS new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case EBike_CY:
        {
            EBikeCY * bike = [EBikeCY new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case PBike_PD:
        {
            PBikePD * bike = [PBikePD new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
        case KBike_KM:
        {
            KBikeKM * bike = [KBikeKM new];
            [bike setValuesForKeysWithDictionary:data];
            [self updateDataFor:bike andUpdateHandler:completeHandler];
        }
            break;
    }
    
}

+ (void)updateDataFor:(id)bikeRealm
      andUpdateHandler:(RealmDataChanged) completeHandler {
    
    dispatch_async(dispatch_queue_create("background", 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSError *error;
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:bikeRealm];
        } error:&error];
        
        if (error == nil) {
            completeHandler(true);
        } else {
            completeHandler(false);
        }
    });
    
}


#pragma mark -Return BikeType Enum from NSString *type
/**
 Return the enum BikeTypes based on the string : Type given
 
 @param type String of the type of the bike 'UBike_NTP', 'UBike_TY', 'TBike_TN', 'CBike_KS', 'IBike_HCC', 'UBike_HC', 'EBike_CY', 'UBike_CH', 'PBike_PD', 'KBike_KM'
 @return BikeTypes enums
 */
+ (BikeTypes) returnBikeTypeEnum:(NSString *) type
{
    
    if ([type containsString:@"UBike"])
    {
        // 'UBike_NTP', 'UBike_TY', 'UBike_HC', 'UBike_CH'
        if ([type containsString:@"_NTP"])
        {
            return UBike_NTP;
        }
        else if ([type containsString:@"_TY"])
        {
            return UBike_TY;
        }
        else if ([type containsString:@"_HC"])
        {
            return UBike_HC;
        }
        else if ([type containsString:@"_TP"]) {
            return UBike_TP;
        }
        else {
            return UBike_CH;
        }
    }
    else if ([type containsString:@"TBike"])
    {
        // 'TBike_TN'
        return TBike_TN;
    }
    else if ([type containsString:@"CBike"])
    {
        // 'CBike_KS'
        return CBike_KS;
    }
    else if ([type containsString:@"IBike"])
    {
        // 'IBike_TC'
        return IBike_TC;
    }
    else if ([type containsString:@"EBike"])
    {
        // 'EBike_CY'
        return EBike_CY;
    }
    else if ([type containsString:@"PBike"])
    {
        // 'PBike_PD'
        return PBike_PD;
    }
    else
    {
        // 'KBike_KM'
        return KBike_KM;
    }
}


@end
