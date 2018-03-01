//
//  ToolBar.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/6.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "ToolBar.h"

//static float const defaultHeight = 44.f;

@implementation ToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/**
Change the Height of NavigationBar

@param size The original size of NavigationBar
@return The final NavigationBar Size with DefaultHeight
*/
- (CGSize) sizeThatFits:(CGSize)size {
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height = ToolBarHeight;
    return amendedSize;
}

+ (float) getDefaultHeight {
    return ToolBarHeight;
}

@end
