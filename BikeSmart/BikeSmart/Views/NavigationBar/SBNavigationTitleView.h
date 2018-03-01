//
//  SBNavigationTitleView.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/21.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JLView.h"
#import "Constants.h"
#import "ImageUtil.h"

typedef NS_ENUM(NSUInteger, CurrentStatus) {
    Status_None,
    Status_Recording,
    Status_Pause,
    Status_Saving,
    Status_Fetching,
};

@interface SBNavigationTitleView : UIView


@end
