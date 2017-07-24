//
//  SideMenuV.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+JLColor.h"
#import "UIView+JLView.h"
#import "UIImage+JLImage.h"
#import "Definitions.h"

@protocol SideMenuDelegate

@end

@interface SideMenuV : UIView
@property (nonatomic, weak) id<SideMenuDelegate> delegate;
@property (nonatomic, strong) NSMutableArray * menuList;
@property (nonatomic) selectedIcon icon;

- (instancetype)initWithMinFrame:(CGRect)minFrame andMaxFrame: (CGRect) maxFrame;

@end
