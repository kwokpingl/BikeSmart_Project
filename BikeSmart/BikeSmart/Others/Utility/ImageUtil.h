//
//  ImageFactory.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/9.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ROOT_CLASS


@interface ImageUtil

typedef NS_ENUM(NSUInteger, WeatherIcon) {
    Sunny = 1,
    PartlySunny,
    MainlySunny,
    Cloudy,
    PartlyCloudy,
    MainlyCloudy,
    Rainy,
    LightRain,
    HeavyRain,
    Storm,
    ThunderStorm,
    Windy,
    Clear,
    Fog,
};

typedef NS_ENUM(NSUInteger, MenuIcon) {
    MenuIcon_MAINMENU = 1,
    MenuIcon_FAVORITE,
    MenuIcon_MAP,
    MenuIcon_STATIONLIST,
    MenuIcon_HISTORY,
    MenuIcon_SEARCH,
    MenuIcon_INFO,
    MenuIcon_EVENTS,
    MenuIcon_NEWS,
    MenuIcon_SETTINGSS,
    MenuIcon_FEEDBACK,
    MenuIcon_FAQ,
    MenuIcon_POLICY,
    MenuIcon_UNKNOWN,
};

typedef NS_ENUM(NSUInteger, OtherIcon) {
    UnderConstruction,
    Icon_FAVORITE,
    Icon_UNFAVORITE,
};

typedef NS_ENUM(NSUInteger, LaunchIcon){
    Icon_Title = 1,
    Icon_Img,
};

typedef NS_ENUM(NSUInteger, NavigationStatus){
    NavStatus_None,
    NavStatus_Recording,
    NavStatus_Pause,
    NavStatus_Saving,
    NavStatus_Fetching,
};

typedef NS_ENUM(NSUInteger, Animation) {
    Animation_NavTitle_Go,
    Animation_NavTitle_End,
};

+ (UIImage *) getLaunchImage:(LaunchIcon) launchIcon;
+ (UIImage *) getWeatherImage:(WeatherIcon) weatherIcon;
+ (UIImage *) getMenuImage:(MenuIcon) menuIcon;
+ (UIImage *) getOtherImage:(OtherIcon) otherIcon;
+ (UIImage *) getNavigationStatusImage:(NavigationStatus)status;
@end
