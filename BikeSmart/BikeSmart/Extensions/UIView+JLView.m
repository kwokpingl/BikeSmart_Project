//
//  UIView+JLView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIView+JLView.h"


@implementation UIView (JLView)

#pragma mark - CHANGE SIDE
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

#pragma mark - SIZE
- (void)changeSizeByPercent:(CGFloat) percentage changeSizeAlong:(ChangeAlong) along {
    CGRect origin_Frame = self.frame;
    
    CGRect new_Frame    = CGRectZero;
    
    CGFloat new_Width   = origin_Frame.size.width * (1.0 + percentage/100.0);
    CGFloat new_Height  = origin_Frame.size.height * (1.0 + percentage/100.0);
    
    CGSize deltaSize    = (CGSize) {origin_Frame.size.width - new_Width, origin_Frame.size.height - new_Height};
    
    CGSize new_Size     = (CGSize) {new_Width, new_Height};
    
    CGFloat new_x = 0;
    CGFloat new_y = 0;
    
    switch (along) {
        case ChangeAlongX:
            new_x = origin_Frame.origin.x;
            new_y = origin_Frame.origin.y + deltaSize.height/2.0;
            break;
        case ChangeAlongY:
            new_x = origin_Frame.origin.x + deltaSize.width/2.0;
            new_y = origin_Frame.origin.y;
            break;
    }
    
    new_Frame = (CGRect) {(CGPoint){new_x, new_y}, new_Size};
    self.frame = new_Frame;
}

- (void)changeSizeTo:(CGSize) size {
    CGPoint origin = self.frame.origin;
    self.frame = (CGRect) {origin, size};
}


#pragma mark - OFFSET
- (void)offSetBy:(CGPoint)origin {
    CGRect origin_Frame = self.frame;
    CGPoint newOrigin   = CGPointMake(origin_Frame.origin.x + origin.x,
                                      origin_Frame.origin.y + origin.y);
    
    CGRect new_Frame    = (CGRect) {newOrigin, origin_Frame.size};
    self.frame = new_Frame;
}

- (void)boundsOffSetBy:(CGPoint)origin {
    CGRect origin_Bound = self.bounds;
    CGPoint newOrigin   = CGPointMake(origin_Bound.origin.x + origin.x,
                                      origin_Bound.origin.y + origin.y);
    CGRect new_Bound = (CGRect) {newOrigin, origin_Bound.size};
    self.bounds = new_Bound;
}

- (void)shiftTo:(CGFloat)margin along:(ChangeAlong)along {
    CGSize newSize = self.frame.size;
    CGPoint oldOrigin = self.frame.origin;
    CGPoint newOrigin = CGPointZero;
    
    switch (along) {
        case ChangeAlongX:
            newOrigin = (CGPoint) {margin, oldOrigin.y};
            break;
        case ChangeAlongY:
            newOrigin = (CGPoint) {oldOrigin.x, margin};
            break;
    }
    
    self.frame = (CGRect) {newOrigin, newSize};
}

- (void)offSetXBy:(CGFloat)x {
    CGRect origin_Frame = self.frame;
    CGPoint newOrigin   = CGPointMake(origin_Frame.origin.x + x,
                                      origin_Frame.origin.y);
    CGRect new_Frame    = (CGRect) {newOrigin, origin_Frame.size};
    self.frame = new_Frame;
}

- (void)offSetYBy:(CGFloat)y {
    CGRect origin_Frame = self.frame;
    CGPoint newOrigin   = CGPointMake(origin_Frame.origin.x,
                                      origin_Frame.origin.y + y);
    CGRect new_Frame    = (CGRect) {newOrigin, origin_Frame.size};
    self.frame = new_Frame;
}

#pragma mark - SUBVIEW
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

- (UIImage *)getViewAsImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
