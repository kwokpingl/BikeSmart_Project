//
//  UIFont+JLFont.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/1.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIFont+JLFont.h"

@implementation UIFont (JLFont)
+ (UIFont *)primaryJLFontWithStyle:(UIFontTextStyle) style {
    return [UIFont fontWithDescriptor:[UIFontDescriptor preferredJLFontDescriptorWithTextStyle:style] size:[UIFontDescriptor currentPreferredSize:style]];
}

+ (UIFont *)JLFontWithStyle:(UIFontTextStyle) style withFontType:(JLFontTypes)type {
    return [UIFont fontWithDescriptor:[UIFontDescriptor JLFontDescriptorWithTextStyle:style fontType:type] size:[UIFontDescriptor currentPreferredSize:style]];
}
@end
