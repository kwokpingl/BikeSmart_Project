//
//  MainVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+JLColor.h"
#import "UIView+JLView.h"
#import "MapVC.h"

#import "ServerConnector.h"
#import "BikeModel.h"
#import "RealmUtil.h"
#import "NavigationMenuButton.h"
#import "JLBarButtonItem.h"

#import "Constants.h"

#import "SBNavigationTitleView.h"
#import "SBGeneralMainViewController.h"
#import "LocationSearchTVC.h"

@interface MainVC : SBGeneralMainViewController <LocationSearchTVCDelegate>


@end
