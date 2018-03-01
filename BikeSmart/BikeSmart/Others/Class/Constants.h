//
//  Constants.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/22.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 By declaring:
 NSString * const kSomeConstantString = @""; // constant pointer

 const NSString * kSomeConstantString = @""; // pointer to constant
 // equivalent to
 NSString const * kSomeConstantString = @"";
 
 */


#pragma mark - DATABASE Keys
extern NSString * const SBDB_Data, * const SBDB_Status, * const SBDB_Longitude, * const SBDB_Latitude, * const SBDB_StationNumber, * const SBDB_ChineseAddress, * const SBDB_ChineseArea, * const SBDB_ChineseStationName, * const SBDB_EnglishAddress, * const SBDB_EnglishArea, * const SBDB_EnglishStationName, * const SBDB_NumberOfBikeAvaliable, * const SBDB_NumberOfEmptySpaces, * const SBDB_TotalParkingSpaces, * const SBDB_BikeType, * const SBDB_LastUpdatedDate, * const SBDB_MainPicture, * const SBDB_AlternativePicture, * const SBDB_IsFavorite;

#pragma mark - URL BASED
extern NSString * const SmartBikerURL;
extern NSString * const SBAPIKey_Data, * const SBAPIKey_Type, * const SBAPIKey_isSuccess;

#pragma mark - API KEYs
extern NSString * const Weather_APIKey, * const Weather_AuthKey;
extern NSString * const Google_APIKey;

#pragma mark - USER DEFAULT KEYs
extern NSString * const UserDefault_BikeType, * const UserDefault_DeltaLng, * const UserDefault_DeltaLat;
extern NSString * const UserDefault_AppleLanguages, * const UserDefault_DisplayLanguages;


#pragma mark - SBNAVIGATIONCONTROLLER SWITCHER KEYs
extern NSString * const SWITCHER_VCTYPE_KEY, * const SWITCHER_VCTYPEDATADICTIONARY_KEY, * const SWITCHER_LNG_KEY, * const SWITCHER_LAT_KEY, * const SWITCHER_STATIONsOnPATH_KEY;

#pragma mark - BIKE MANAGER KEYs
extern NSString * const BIKE_MODELs_KEY;

#pragma mark - NOTIFICATION NAMEs
extern NSString * const Notification_UserLocation, * const Notification_CameraLocation;
extern NSString * const Notification_UserStatusChanged, * const Notification_UserStatusChangedKey;
extern NSString * const Notification_NavigationSwitchTrigger;
extern NSString * const Notification_RealmUpdated;
extern NSString * const Notification_UpdateBikeModels;
extern NSString * const Notification_BikeManagerNewModels, * const Notification_BikeManagerModelUpdated;

#pragma mark - CONSTANT NUMBERs
extern const float NavigationBarHeight;
extern const float ToolBarHeight;
extern const float MenuToMainViewWidthRatio;
extern const float DELTA_LAT, DELTA_LNG;
