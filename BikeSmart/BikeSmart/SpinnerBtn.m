//
//  SpinnerBtn.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SpinnerBtn.h"

@interface SpinnerBtn(){
    NSArray * titles;
    NSMutableArray * views;
}

@end


@implementation SpinnerBtn


- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles Views:(UIView *)view, ... {
    self = [super initWithFrame:frame];
    self->titles = titles;
    views = [NSMutableArray new];
    
    va_list args;
    
    if (view != nil) {
        va_start(args, view);
        
        for (UIView * arg = view; arg != nil; arg = va_arg(args, UIView *)) {
            [views addObject:arg];
        }
        
    }
    
    va_end(args);
    
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
