//
//  UIView+JLView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIView+JLView.h"

@implementation UIView (JLView)

-(void)setHeight:(CGFloat)height {
    CGRect origin_Frame = self.frame;
    CGRect new_Frame    = (CGRect) {origin_Frame.origin, origin_Frame.size.width, height};
    // {x,y,w,h}
    self.frame = new_Frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect origin_Frame = self.frame;
    CGRect new_Frame    = (CGRect) {origin_Frame.origin, width,origin_Frame.size.height};
    // {x,y,w,h}
    self.frame = new_Frame;
}

- (void)offSetBy:(CGPoint)origin {
    CGRect origin_Frame = self.frame;
    CGRect new_Frame    = (CGRect) {origin, origin_Frame.size};
    self.frame = new_Frame;
}

- (void)addConstraintWithFormat:(NSString *)format views:(UIView *)view, ... NS_REQUIRES_NIL_TERMINATION {
    // Ex: "H: |[v0][v2]|"
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    
    int counter = -1;
    va_list args; // A pointer to a list of variable arguments.
    va_start(args, view);
    
    for (UIView * arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        // Fetches the next argument out of the list. You must specify the type of the argument (so that va_arg knows how many bytes to extract).
        
        counter += 1;
        NSString * key = [@"v" stringByAppendingString:[NSString stringWithFormat:@"%d", counter]];
        dict[key] = arg;
    }
        
    va_end(args);   // Releases any memory held by the va_list data structure.
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict]];
    
}

@end
