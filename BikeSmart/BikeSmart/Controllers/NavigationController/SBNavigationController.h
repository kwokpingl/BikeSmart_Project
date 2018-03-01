//
//  SBNavigationController.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+JLColor.h"
#import "UIView+JLView.h"
#import "ContentNavigationBar.h"
#import "Constants.h"

#import "ToolBar.h"
#import "ServerConnector.h"
#import "SBNavigationTitleView.h"

#import "MainVC.h"
#import "SBStationListVC.h"

/*
 @"Map",
 @"Station List",
 @"History",
 @"News",
 @"Events",
 @"Settings",
 @"Policy",
 @"FAQ",
 @"Feedback"
 */

typedef NS_ENUM(NSUInteger, VCTypes) {
    VCType_MAP,
    VCType_LIST,
    VCType_HISTORY,
    VCType_NEWS,
    VCType_EVENTS,
    VCType_SETTINGS,
    VCType_POLICY,
    VCType_FAQ,
    VCType_FEEDBACK,
};

@protocol SBNavigationControllerDelegate <NSObject>

- (void)openMenu;

@end

@interface SBNavigationController : UINavigationController <SBGeneralMainViewControllerDelegate>

@property (nonatomic, weak) id<SBNavigationControllerDelegate> openMenuDelegate;

-(void)goToHomePage;
-(void)openMenu;

@end
