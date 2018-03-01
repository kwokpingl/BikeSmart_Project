//
//  SBGeneralMainViewController.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/16.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+JLColor.h"
#import "UIView+JLView.h"

#import "ContentNavigationBar.h"
#import "ToolBar.h"
#import "Constants.h"

#import "ImageUtil.h"

@protocol SBGeneralMainViewControllerDelegate <NSObject>

- (void)openMenu;

@end

@interface SBGeneralMainViewController : UIViewController
@property (nonatomic, weak) id<SBGeneralMainViewControllerDelegate>generalDelegate;
- (void)rightItemButtonPressed;
- (void)leftItemButtonPressed;
@end
