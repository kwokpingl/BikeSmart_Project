//
//  ScrollButtonMileStone.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/18.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLScrollMileStoneButton : UIButton
IBInspectable
@property (nonatomic) UIColor *fillColorSelected, *fillColorDeselected;
@property (nonatomic) UIColor *borderColorSelected, *borderColorDeselected;
//@property (nonatomic) UIColor ;
- (instancetype)initWithFrame:(CGRect)frame
                       insets:(UIEdgeInsets) insets;
@end
