//
//  UILabel+JLLabel.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UILabel+JLLabel.h"

@implementation UILabel (JLLabel)
-(CGFloat)getHeightWith:(CGFloat)width {
    
//    CGRect frame = CGRectMake(0, 0, width, 100);
//    UILabel * lab = [[UILabel alloc] initWithFrame:frame];
//    [lab setNumberOfLines:0];
//    
//    [lab addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//    
//    [lab setText:str];
//    
//    return lab.frame.size.height;
    
    CGSize maxLabelSize = CGSizeMake(width, FLT_MAX);
    // FLT_MAX
    // 0x1.fffffep+127 is (roughly) 1.99999999999999999999998 times 2^127.
    
    CGRect expectedSize = [self.text boundingRectWithSize:maxLabelSize
                                                  options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: self.font}
                                                  context:nil];
    return expectedSize.size.height;
}
@end
