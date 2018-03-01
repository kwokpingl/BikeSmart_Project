//
//  LaunchVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/18.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+JLView.h"
#import "ServerConnector.h"
#import "BikeModel.h"
#import "RealmUtil.h"
#import "Definitions.h"

#import "MainVC.h"
#import "SBGrandMasterVC.h"

#import "FlipPresentAnimationController.h"
#import "JLScrollMileStoneView.h"
#import "SBNavigationController.h"
#import "ContentNavigationBar.h"
#import "ToolBar.h"

@interface LaunchVC : UIViewController <UIViewControllerTransitioningDelegate, FlipPresentAnimationControllerDelegate, JLScrollMileStoneViewDelegate>
@end
