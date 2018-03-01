//
//  ImageFactory.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/9.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageUtil.h"


@interface ImageUtil()



@end

@implementation ImageUtil

+ (UIImage *) getLaunchImage:(LaunchIcon) launchIcon {
    
    NSString *imageName = @"";
    
    switch (launchIcon) {
        case Icon_Img:
            imageName = @"Icon_LaunchScreen";
            break;
        case Icon_Title:
            imageName = @"MainIconBlack";
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

//+ (UIImage *) getLaunchAnimateImage:()

+ (UIImage *)getWeatherImage:(WeatherIcon)weatherIcon {
    
    NSString * imageName = @"UnderConstruction";
    
    switch (weatherIcon) {
        case Sunny:
            NSLog(@"Sunny");
            break;
            
        default:
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

+ (UIImage *)getMenuImage:(MenuIcon)menuIcon {
    NSString * imageName = @"UnderConstruction";
    switch (menuIcon) {
        case MenuIcon_MAINMENU:
            imageName = @"Icon_Menu";
            break;
        case MenuIcon_MAP:
            imageName = @"Icon_Map";
            break;
        case MenuIcon_FAVORITE:
            imageName = @"Icon_Favorite";
            break;
        case MenuIcon_SEARCH:
            imageName = @"Icon_Search";
            break;
        case MenuIcon_STATIONLIST:
            imageName = @"Icon_StationList";
            break;
        default:
            imageName = @"Icon_Unknown";
            break;
    }
    
    return [UIImage imageNamed:imageName];
}


/**
 getOtherImage

 @param otherIcon UnderConstruction, Favorite, UnFavorite Icons
 @return UIImage
 */
+ (UIImage *)getOtherImage:(OtherIcon)otherIcon {
    NSString * imageName = @"UnderConstruction";
    
    switch (otherIcon) {
        case UnderConstruction:
            
            break;
            
        case Icon_FAVORITE:
            imageName = @"Icon_Favorite";
            break;
            
        case Icon_UNFAVORITE:
            imageName = @"Icon_UnFavorite";
            break;
        default:
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

+ (UIImage *)getNavigationStatusImage:(NavigationStatus)status {
    NSString *imageName = @"MainIcon";
    switch (status) {
        case NavStatus_None:
            imageName = @"Nav_Title_None";
            break;
        case NavStatus_Pause:
            break;
        case NavStatus_Saving:
            break;
        case NavStatus_Fetching:
            break;
        case NavStatus_Recording:
            break;
    }
    return [UIImage imageNamed:imageName];
}

+ (NSArray <UIImage *> *)getNavigationTitleAnimateImages:(Animation)animation {
    
    switch (animation) {
        case Animation_NavTitle_Go:
        {
            UIImage *none   = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *ready  = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *set1   = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *set2   = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *go     = [UIImage imageNamed:@"Nav_Title_None"];
            return @[none, ready, set1, set2, go];
        }
            break;
        case Animation_NavTitle_End:
        {
            UIImage *none   = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *ready  = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *set1   = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *set2   = [UIImage imageNamed:@"Nav_Title_None"];
            UIImage *go     = [UIImage imageNamed:@"Nav_Title_None"];
            return @[go, set2, set1, ready, none];
        }
            break;
    }
    
}


@end
