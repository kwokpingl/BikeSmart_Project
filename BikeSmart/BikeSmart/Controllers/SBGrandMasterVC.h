//
//  SBGrandMasterVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/26.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JLView.h"

#pragma mark - IMPORT VIEW CONTROLLERs
#import "SBNavigationController.h"
#import "MenuVC.h"
#import "BikeModelManager.h"


@interface SBGrandMasterVC : UIViewController <UIGestureRecognizerDelegate, SBNavigationControllerDelegate, MenuVCDelegate>

@end
