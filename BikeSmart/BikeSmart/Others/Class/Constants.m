//
//  Constants.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/22.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "Constants.h"

#pragma mark - DATABASE KEYs
NSString * const SBDB_Data                   = @"data";
NSString * const SBDB_Status                 = @"act";
NSString * const SBDB_Longitude              = @"lng";
NSString * const SBDB_Latitude               = @"lat";
NSString * const SBDB_StationNumber          = @"stnNO";
NSString * const SBDB_ChineseAddress         = @"adCn";
NSString * const SBDB_ChineseArea            = @"saCn";
NSString * const SBDB_ChineseStationName     = @"snCn";
NSString * const SBDB_EnglishAddress         = @"adEn";
NSString * const SBDB_EnglishArea            = @"saEn";
NSString * const SBDB_EnglishStationName     = @"snEn";
NSString * const SBDB_NumberOfBikeAvaliable  = @"bikes";
NSString * const SBDB_NumberOfEmptySpaces    = @"spaces";
NSString * const SBDB_TotalParkingSpaces     = @"tot";
NSString * const SBDB_BikeType               = @"type";
NSString * const SBDB_LastUpdatedDate        = @"uDate";
NSString * const SBDB_MainPicture            = @"pic1";
NSString * const SBDB_AlternativePicture     = @"pic2";
NSString * const SBDB_IsFavorite             = @"isFavorite";

#pragma mark - USER DEFAULT KEYs
NSString * const UserDefault_BikeType = @"bikeTypes";
NSString * const UserDefault_DeltaLng = @"deltaLng";
NSString * const UserDefault_DeltaLat = @"deltaLat";
NSString * const UserDefault_AppleLanguages = @"AppleLanguages";
NSString * const UserDefault_DisplayLanguages = @"DisplayLanguage";

#pragma mark - URL BASEd
NSString * const SBAPIKey_Data = @"data";
NSString * const SBAPIKey_Type = @"types";
NSString * const SBAPIKey_isSuccess = @"isSuccess";
NSString * const SmartBikerURL = @"http://jimmy-maltose.appjam.space/BikeSmart/";

#pragma mark - API KEYs
NSString * const Weather_APIKey = @"CWB-E94954C0-74A4-4E74-9711-795021B29C4C";
NSString * const Weather_AuthKey = @"Authorization";
NSString * const Google_APIKey   = @"AIzaSyCr1qmNgwx4-GjvL6dJyqz7ETJf2bChSuI";


#pragma mark - NOTIFICATION NAMEs
NSString * const Notification_UserLocation = @"userLocationUpdated";
NSString * const Notification_CameraLocation = @"cameraLocationUpdated";
NSString * const Notification_UserStatusChanged = @"userStatusChanged";
NSString * const Notification_UserStatusChangedKey = @"userStatusChangedKey";
NSString * const Notification_NavigationSwitchTrigger = @"timeToSwitchVC";
NSString * const Notification_RealmUpdated = @"realmUpdated";
NSString * const Notification_UpdateBikeModels = @"updateBikeModels";
NSString * const Notification_BikeManagerNewModels = @"newModels";
NSString * const Notification_BikeManagerModelUpdated = @"modelUpdated";

#pragma mark - SBNAVIGATIONCONTROLLER SWITCHER KEYs
NSString * const SWITCHER_VCTYPE_KEY = @"vctype";
NSString * const SWITCHER_VCTYPEDATADICTIONARY_KEY = @"data";
NSString * const SWITCHER_LNG_KEY = @"lng";
NSString * const SWITCHER_LAT_KEY = @"lat";
NSString * const SWITCHER_STATIONsOnPATH_KEY = @"stationsOnThePath";

#pragma mark - BIKE MANAGER KEYs
NSString * const BIKE_MODELs_KEY = @"data";

#pragma mark - CONSTANT NUMBERs
// No difference between const double and double const
const float NavigationBarHeight = 44.0f;
const float ToolBarHeight = 44.0f;
const float MenuToMainViewWidthRatio = 1.0/3.0;

const float DELTA_LAT = 0.3;
const float DELTA_LNG = 1;
