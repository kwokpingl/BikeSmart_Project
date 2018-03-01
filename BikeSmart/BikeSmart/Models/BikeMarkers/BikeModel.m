//
//  BikeModel.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/14.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BikeModel.h"

@interface BikeModel()
{
    int         _stnNO, _tot, _bikes, _spaces;
    double      _lat, _lng;
    BOOL        _act;
    BikeTypes   _bikeType;
    
    NSString    *_adCn;
    NSString    *_adEn;
    NSString    *_snCn;
    NSString    *_snEn;
    NSString    *_saCn;
    NSString    *_saEn;
    
    NSString    *_districtCn;
    NSString    *_districtEn;
    
    NSString    *_pic1;
    NSString    *_pic2;
    
    NSDate      *_uDate;
    
    NSString    *_imageName;
    DisplayLanguage _displayLanguage;
    
    NSString    *_bikeTypeString;
    
    NSMutableDictionary *_bikeDictionary;
    
    UIColor     *_primaryColor, *_secondaryColor, *_tertiaryColor;
}
@end

@implementation BikeModel
#pragma mark - CLASS METHODs
+ (NSArray *) bikeTypesToStringArrayConverter:(NSArray *) bikeEnumInts
{
    NSMutableArray * mutableArray = [NSMutableArray new];
    
    for (NSNumber * bikeType in bikeEnumInts)
    {
        NSString *bike = [BikeModel bikeTypeEnumToString:(BikeTypes)[bikeType integerValue]];
        [mutableArray addObject:bike];
    }
    
    return [[NSArray alloc] initWithArray:mutableArray];
}

+ (NSString *)bikeTypeEnumToString:(BikeTypes) type {
    NSString *bike = @"";
    
    switch (type) {
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
    
    return bike;
}

+ (NSString *)bikeTypeToIconString:(BikeTypes) type {
    NSString *bike = @"";
    
    switch (type) {
        case CBike_KS:
            bike = @"C";
            break;
        case EBike_CY:
            bike = @"E";
            break;
        case IBike_TC:
            bike = @"I";
            break;
        case KBike_KM:
            bike = @"K";
            break;
        case PBike_PD:
            bike = @"P";
            break;
        case TBike_TN:
            bike = @"T";
            break;
        case UBike_CH:
        case UBike_HC:
        case UBike_NTP:
        case UBike_TY:
        case UBike_TP:
            bike = @"U";
            break;
    }
    
    return bike;
}

#pragma mark - BIKE MODEL PARSER
- (NSDictionary *) bikeModelParser {
    return (NSDictionary *)_bikeDictionary;
}

#pragma mark - INSTANCE METHODs
- (instancetype)init:(NSDictionary *) bikeData for:(BikeTypes) bikeType
{
    self = [super init];
    
    if (self)
    {
        _stnNO      = [bikeData[SBDB_StationNumber] intValue];
        _tot        = [bikeData[SBDB_TotalParkingSpaces] intValue];
        _bikes      = [bikeData[SBDB_NumberOfBikeAvaliable] intValue];
        _spaces     = [bikeData[SBDB_NumberOfEmptySpaces] intValue];
        _lat        = [bikeData[SBDB_Latitude] doubleValue];
        _lng        = [bikeData[SBDB_Longitude] doubleValue];
        _act        = [bikeData[SBDB_Status] boolValue];
        _isFavorite = [bikeData[SBDB_IsFavorite] boolValue];
        _bikeType   = bikeType;
        
        [self setDistrict:bikeType];
        
        _adCn       = bikeData[SBDB_ChineseAddress];
        _adEn       = bikeData[SBDB_EnglishAddress];
        _snCn       = bikeData[SBDB_ChineseStationName];
        _snEn       = bikeData[SBDB_EnglishStationName];
        _saCn       = bikeData[SBDB_ChineseArea];
        _saEn       = bikeData[SBDB_EnglishArea];
        
        _pic1       = bikeData[SBDB_MainPicture];
        _pic2       = bikeData[SBDB_AlternativePicture];
        
        _uDate      = bikeData[SBDB_LastUpdatedDate];
        
        _bikeDictionary = [[NSMutableDictionary alloc] initWithDictionary:bikeData];
        
        _bikeTypeString = [BikeModel bikeTypeToIconString:_bikeType];
        
        [self setImageName];
        [self setBikeColors:bikeType];
        
        _displayLanguage = (DisplayLanguage) [[NSUserDefaults standardUserDefaults] integerForKey:@"DisplayLanguage"];
    }
    
    return self;
}

- (void) setImageName
{
    
    int percentage = (double)_spaces/(double)_tot * 100;
    switch (_bikeType) {
        case UBike_CH:
        case UBike_HC:
        case UBike_TY:
        case UBike_NTP:
            _imageName = @"YouBike";
            break;
            
        case CBike_KS:
            _imageName = @"CityBike";
        default:
            break;
    }
    
    NSString *percentagePart = @"";
    
    if (percentage == 0)
    {
        percentagePart = [NSString stringWithFormat:@"(%@)", @"empty"];
    }
    else if (percentage > 0 && percentage < 21)
    {
        percentagePart = [NSString stringWithFormat:@"(%@)", @"20%"];
    }
    else if (percentage > 20 && percentage <41)
    {
        percentagePart = [NSString stringWithFormat:@"(%@)", @"40%"];
    }
    else if (percentage > 40 && percentage < 61)
    {
        percentagePart = [NSString stringWithFormat:@"(%@)", @"60%"];
    }
    else if (percentage > 60 && percentage < 81)
    {
        percentagePart = [NSString stringWithFormat:@"(%@)", @"80%"];
    }
    else
    {
        percentagePart = [NSString stringWithFormat:@"(%@)", @"100%"];
    }
    
    _imageName = [NSString stringWithFormat:@"%@ %@", _imageName, percentagePart];
}

- (void)setBikeColors:(BikeTypes) type {
    switch (type) {
        case CBike_KS:
            _primaryColor   = [UIColor colorWithHexString:@"D8EBF3"];
            _secondaryColor = [UIColor colorWithHexString:@"1A7CC0"];
            _tertiaryColor  = [UIColor colorWithHexString:@"A5C85F"];
            break;
        case EBike_CY:
            _primaryColor   = [UIColor colorWithHexString:@"E44B1F"];
            _secondaryColor = [UIColor colorWithHexString:@"217D3D"];
            _tertiaryColor  = [UIColor colorWithHexString:@"64AEC6"];
            break;
        case IBike_TC:
            _primaryColor   = [UIColor colorWithHexString:@"61A73D"];
            _secondaryColor = [UIColor colorWithHexString:@"EFE573"];
            _tertiaryColor  = [UIColor colorWithHexString:@"A4D57E"];
            break;
        case KBike_KM:
            _primaryColor   = [UIColor colorWithHexString:@"A447FF"];
            _secondaryColor = [UIColor colorWithHexString:@"EEEEE6"];
            _tertiaryColor  = [UIColor colorWithHexString:@"FFF467"];
            break;
        case PBike_PD:
            _primaryColor   = [UIColor colorWithHexString:@"FCE54B"];
            _secondaryColor = [UIColor colorWithHexString:@"DACCBF"];
            _tertiaryColor  = [UIColor colorWithHexString:@"C8F6FD"];
            break;
        case TBike_TN:
            _primaryColor   = [UIColor colorWithHexString:@"61A73D"];
            _secondaryColor = [UIColor colorWithHexString:@"EFE573"];
            _tertiaryColor  = [UIColor colorWithHexString:@"A4D57E"];
            break;
        case UBike_CH:
        case UBike_HC:
        case UBike_NTP:
        case UBike_TY:
        case UBike_TP:
            _primaryColor   = [UIColor colorWithHexString:@"FFD147"];
            _secondaryColor = [UIColor colorWithHexString:@"19834B"];
            _tertiaryColor  = [UIColor colorWithHexString:@"FF9A67"];
            break;
    }
    
}

- (void) setDistrict:(BikeTypes) bikeType {
    switch (bikeType) {
        case UBike_NTP:
            _districtCn = @"新北市";
            _districtEn = @"New Taipei City";
            break;
        case UBike_TY:
            _districtCn = @"桃園市";
            _districtEn = @"Taoyuam City";
            break;
        case UBike_TP:
            _districtCn = @"台北市";
            _districtEn = @"Taipei City";
            break;
        case UBike_CH:
            _districtCn = @"彰化縣";
            _districtEn = @"Changhue County";
            break;
        case UBike_HC:
            _districtCn = @"新竹市";
            _districtEn = @"Hsinchu City";
            break;
        case TBike_TN:
            _districtCn = @"台南市";
            _districtEn = @"Tainan City";
            break;
        case PBike_PD:
            _districtCn = @"屏東縣";
            _districtEn = @"Pingtung County";
            break;
        case KBike_KM:
            _districtCn = @"金門縣";
            _districtEn = @"Kimen County";
            break;
        case IBike_TC:
            _districtCn = @"台中市";
            _districtEn = @"Taichung City";
            break;
        case EBike_CY:
            _districtCn = @"嘉義市";
            _districtEn = @"Chiayi City";
            break;
        case CBike_KS:
            _districtCn = @"高雄市";
            _districtEn = @"Kaohsiung City";
            break;
    }
}

#pragma mark - GETTERs
// GET IMAGE NAME for MARKER
- (NSString *) getImageName
{
    return _imageName;
}

// GET STATION NUMBER OF the STATION
- (int) getStationNumber
{
    return _stnNO;
}

// GET CURRENT AVALIABLE BIKEs
- (int) getBikeNumber
{
    return _bikes;
}

// GET CURRENT EMPTY SPACEs
- (int) getSpaceNumber
{
    return _spaces;
}

// GET OVERALL (BIKEs + SPACEs)
- (int) getTotalSpaces
{
    return _tot;
}

// GET the BIKE TYPE of the STATION ie UBike, CBike, ...
- (BikeTypes) getBikeType
{
    return _bikeType;
}

// GET the COORDINATION of the STATION
- (CLLocation *) getCoordinate
{
    return [[CLLocation alloc] initWithLatitude:_lat longitude:_lng];
}

// GET the ADDRESS of the STATION
- (NSString *) getAddress
{
    switch (_displayLanguage) {
        case En:
            return _adEn;
            break;
        case Zh:
            return _adCn;
            break;
    }
}

// GET the NAME of the STATION
- (NSString *) getStationName
{
    switch (_displayLanguage) {
        case En:
            return _snEn;
            break;
        case Zh:
            return _snCn;
            break;
    }
}

// GET the AREA of the STATION
- (NSString *) getStationArea
{
    switch (_displayLanguage) {
        case En:
            return _saEn;
            break;
        case Zh:
            return _saCn;
            break;
    }
}

- (NSString *) getStationDistrict {
    switch (_displayLanguage) {
        case En:
            return _districtEn;
            break;
            
        case Zh:
            return _districtCn;
            break;
    }
}

// GET the URLs of PICTUREs
- (NSArray<NSURL *> *) getPicURLs
{
    NSURL *urlPic1;
    NSURL *urlPic2;
    NSMutableArray * finalArray = [NSMutableArray new];
    if (_pic1 != nil)
    {
        urlPic1  = [NSURL URLWithString:_pic1];
        [finalArray addObject:urlPic1];
    }
    if (_pic2 != nil)
    {
        urlPic2   = [NSURL URLWithString:_pic2];
        [finalArray addObject:urlPic2];
    }
    
    return [[NSArray alloc] initWithArray:finalArray];
}

// GET the UPDATED DATE and TIME
- (NSString *) getUpdatedDate
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:_uDate];
}

// GET bikeType in String
- (NSString *) getUniqueKey {
    
    NSString *bikeTypeName = [BikeModel bikeTypeEnumToString:_bikeType];
    
    NSString *uniqueString = [NSString stringWithFormat:@"%@ <%d>", bikeTypeName, _stnNO];
    
    return uniqueString;
}

- (NSString *) getBikeTypeString {
    return _bikeTypeString;
}

- (UIColor *) getPrimaryColor {
    return _primaryColor;
}

- (UIColor *) getSecondaryColor {
    return _secondaryColor;
}

- (UIColor *) getTertiaryColor {
    return _tertiaryColor;
}


- (NSString *) getDistrictLocation {
    return @"";
}

#pragma mark - COMPARATORs
-(BOOL)isEqual:(id)object {
    return _stnNO == [((BikeModel *) object) getStationNumber];
}

@end
