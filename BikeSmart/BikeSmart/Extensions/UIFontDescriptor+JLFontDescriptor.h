//
//  UIFontDescriptor+JLFontDescriptor.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/1.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JLTextStyleCaption3;

typedef NS_ENUM(NSUInteger, JLFontTypes) {
    JLFONTTYPES_CAVIARDREAMS_NORMAL,
    JLFONTTYPES_CAVIARDREAMS_BOLD,
    JLFONTTYPES_CAVIARDREAMS_OLDITALIC,
    JLFONTTYPES_CAVIARDREAMS_ITALIC,
};

@interface UIFontDescriptor (JLFontDescriptor)
+ (UIFontDescriptor *)preferredJLFontDescriptorWithTextStyle:(UIFontTextStyle)style;
+(UIFontDescriptor *)JLFontDescriptorWithTextStyle:(UIFontTextStyle)style
                                          fontType:(JLFontTypes) type;
+(CGFloat)currentPreferredSize:(UIFontTextStyle)style;
@end
