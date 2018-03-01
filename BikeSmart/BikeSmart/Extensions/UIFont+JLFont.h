//
//  UIFont+JLFont.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/1.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFontDescriptor+JLFontDescriptor.h"

@interface UIFont (JLFont)
+ (UIFont *)primaryJLFontWithStyle:(UIFontTextStyle)style ;
+ (UIFont *)JLFontWithStyle:(UIFontTextStyle)style
               withFontType:(JLFontTypes)type;
@end
