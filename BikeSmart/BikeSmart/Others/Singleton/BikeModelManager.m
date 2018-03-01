//
//  BikeModelManager.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/25.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeModelManager.h"

@interface BikeModelManager()
@property (nonatomic) NSMutableDictionary <NSString *, BikeModel *> *UBikeModels, *CBikeModels, *EBikeModels, *IBikeModels, *KBikeModels, *PBikeModels, *TBikeModels, *FavoriteModels;
@property (nonatomic) NSMutableDictionary <NSString *, BikeModel *> *modelDictionary;
@property (nonatomic) BOOL isFetching, isUpdating;
@property (nonatomic) NSTimer *updateTimer;
@end

@implementation BikeModelManager

#pragma mark - CLASS METHODs

#pragma mark - INSTANCE METHODs
+ (id)shared {
    static BikeModelManager *shared = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        if (shared == nil) {
            shared = [BikeModelManager new];
            shared.modelDictionary = [NSMutableDictionary new];
            shared.UBikeModels = [NSMutableDictionary new];
            shared.CBikeModels = [NSMutableDictionary new];
            shared.EBikeModels = [NSMutableDictionary new];
            shared.IBikeModels = [NSMutableDictionary new];
            shared.KBikeModels = [NSMutableDictionary new];
            shared.PBikeModels = [NSMutableDictionary new];
            shared.TBikeModels = [NSMutableDictionary new];
            shared.FavoriteModels = [NSMutableDictionary new];
            shared.isFetching = false;
        }
    });
    
    if (shared.updateTimer == nil) {
        __weak BikeModelManager *weakSelf = shared;
                
        shared.updateTimer = [NSTimer scheduledTimerWithTimeInterval:[UserDefaults getUpdateTimeInterval] repeats:true block:^(NSTimer * _Nonnull timer) {
            [weakSelf updateDatawithHandler:nil];
        }];
        
        [shared.updateTimer fire];
    }
    
    return shared;
}

- (void)updateDatawithHandler:(CompletionProgressHandler _Nullable)progressHandler {
    
    NSArray <NSNumber *> *bikeStationTypes = [UserDefaults getSelectedBikeTypes];
    
    __weak BikeModelManager *weakSelf = [BikeModelManager shared];
    
    // Connect to Server
    [[ServerConnector sharedInstance] fetchBikeData:bikeStationTypes completeHandler:^(NSDictionary * _Nullable data, NSError * _Nullable internetError, NSError * _Nullable jsonError, BOOL isSuccess) {
        
        if (internetError != nil)
        {
            NSLog(@"Error Occured at %s : %@", __FUNCTION__, internetError.localizedDescription);
            weakSelf.isFetching = false;
            return;
        }
        
        if (jsonError != nil) {
            NSLog(@"Error Occured at %s : %@", __FUNCTION__, jsonError.localizedDescription);
            weakSelf.isFetching = false;
            return;
        }
        
        if (isSuccess)//[data[SBAPIKey_isSuccess] boolValue])
        {
            weakSelf.isUpdating = true;
            // Write into Realm
            [RealmUtil updateBikeRealmsWithDictionary:data[SBAPIKey_Data] updateHandler:^(BOOL isLastOne, int percentage) {
                
                if (progressHandler != nil) {
                    progressHandler(percentage);
                }
                
                // Fetch data for current location
                if (isLastOne && percentage == 100) {
                    weakSelf.isUpdating = false;
                    [weakSelf fetchDataWithCoordinate:nil];
                }
                
            }];
            
        }
        
        
    }];
    
    
}

- (void)fetchDataWithCoordinate:(CLLocation * _Nullable) coordinate {
    
    if (_isUpdating) { // return if data is being changed
        return;
    }
    
    __weak BikeModelManager *weakSelf = self;
    
    if (coordinate == nil) {
        [RealmUtil getSelectedBikeRealm:^(NSDictionary<NSNumber *,NSArray<BikeModel *> *> * _Nonnull data) {
            [weakSelf filterDataAndNotify:data];
        }];
    } else {
        
        __block CLLocation *previousCoordinate = coordinate;
        
        [RealmUtil getBikeRealmAtLocation:coordinate.coordinate completeHandler:^(NSDictionary<NSNumber *,NSArray<BikeModel *> *> * _Nonnull data, CLLocationCoordinate2D coordinate) {
            
            CGFloat inputLat = previousCoordinate.coordinate.latitude;
            CGFloat inputLng = previousCoordinate.coordinate.longitude;
            
            CGFloat blockLat = coordinate.latitude;
            CGFloat blockLng = coordinate.longitude;
            
            if (inputLat != blockLat && inputLng != blockLng){
                return;
            }
            
            [weakSelf filterDataAndNotify:data];
            
        }];
    }
}

#pragma mark - INTERNAL METHODs

- (void)filterDataAndNotify:(NSDictionary<NSNumber *,NSArray<BikeModel *> *> *)data {
    
    
    NSMutableDictionary<NSNumber *,NSArray<BikeModel *> *> *newModels = [NSMutableDictionary new];
    
    for (NSNumber *bikeTypeRaw in data.allKeys) {
        NSArray <BikeModel *> *bikeDataArray = data[bikeTypeRaw];
        
        NSArray<BikeModel *> *newData = [self filteredData:bikeDataArray];
        
        if (newData.count <= 0) {
            continue;
        }
        
        newModels[bikeTypeRaw] = newData;
    }
    
    if (newModels.allKeys.count > 0) {
        // NOTIFY MAP that NEW MODELs are ready to show
        // This is mainly for map to display new Markers
        [SBNotificationCenter postNewModelReadyToDisplay:newModels withObject:self];
    }
    
}

- (NSArray <BikeModel *> *)filteredData:(NSArray <BikeModel *> *) models {
    NSMutableArray <BikeModel *> *newData = [NSMutableArray new];
    
    for (BikeModel *model in models) {
        
        [self renewGeneralModels:model andUpdateNewModels:newData];
        
        [self renewBikeModels:model];
        
    }
    
    [SBNotificationCenter postGeneralModelUpdated:[[NSDictionary alloc] initWithDictionary:_modelDictionary] withObject:self];
    
    return newData;
}

- (void)renewGeneralModels:(BikeModel *)model
        andUpdateNewModels:(NSMutableArray <BikeModel *> *) newData{
    NSString *key   = [model getUniqueKey];
    BOOL isFavorite = [model isFavorite];
    
    if (isFavorite) {
        
        // CHECK if _FavoriteModels == nil || _FavoriteModels[key] == nil
        if (_FavoriteModels[key] == nil) {
            [newData addObject:model];
        }
        
        // IF isFavorite, then REMOVE the model from _modelDictionary
        if (_modelDictionary[key] != nil) {
            [_modelDictionary removeObjectForKey:key];
        }
        
        _FavoriteModels[key] = model;
        
    } else {
        
        if (_modelDictionary[key] == nil){
            [newData addObject:model];
        }
        
        if (_FavoriteModels[key] != nil) {
            [_FavoriteModels removeObjectForKey:key];
        }
        
        _modelDictionary[key] = model;
    }
    
}

- (void)renewBikeModels:(BikeModel *)model {
    
    NSString *key = [model getUniqueKey];
    
    switch ([model getBikeType]) {
        case UBike_CH:
        case UBike_HC:
        case UBike_TP:
        case UBike_TY:
        case UBike_NTP:
            _UBikeModels[key] = model;
            break;
        case CBike_KS:
            _CBikeModels[key] = model;
            break;
        case EBike_CY:
            _EBikeModels[key] = model;
            break;
        case IBike_TC:
            _IBikeModels[key] = model;
            break;
        case KBike_KM:
            _KBikeModels[key] = model;
            break;
        case PBike_PD:
            _PBikeModels[key] = model;
            break;
        case TBike_TN:
            _TBikeModels[key] = model;
            break;
    }
}

#pragma mark - GET METHODs
- (NSMutableDictionary *)getModelsFor:(BikeTypes) bikeType{
    switch (bikeType) {
        case UBike_NTP:
        case UBike_TY:
        case UBike_TP:
        case UBike_HC:
        case UBike_CH:
            return _UBikeModels;
            break;
        case TBike_TN:
            return _TBikeModels;
            break;
        case PBike_PD:
            return _PBikeModels;
            break;
        case KBike_KM:
            return _KBikeModels;
            break;
        case IBike_TC:
            return _IBikeModels;
            break;
        case EBike_CY:
            return _EBikeModels;
            break;
        case CBike_KS:
            return _CBikeModels;
            break;
    }
}

- (NSMutableDictionary *)getFavorites{
    return _FavoriteModels;
}

- (NSMutableDictionary *)getAllModel {
    return _modelDictionary;
}

#pragma mark - API for UPDATING BIKEMODELs' DATA
- (void)changeFavoriteBikeModel:(BikeModel *)bikeModel
                completeHandler:(RealmDataChanged)completeHandler{
    [bikeModel setFavorite:!bikeModel.isFavorite];
    [RealmUtil updateBikeModel:bikeModel completeHandler:completeHandler];
}



@end
