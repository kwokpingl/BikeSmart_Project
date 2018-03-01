//
//  MenuVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/2.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageUtil.h"
#import "Constants.h"

#import "SBNavigationController.h"
#import "ImageUtil.h"
#import "UIFont+JLFont.h"

@protocol MenuVCDelegate

- (void)switchToViewController:(VCTypes) type;

@end

@interface MenuVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<MenuVCDelegate> menuVCDelegate;

@end
