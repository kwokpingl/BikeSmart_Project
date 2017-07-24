//
//  SideMenuV.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SideMenuV.h"

#define X(a)    @#a
NSString * const enumAsString[] = {\
    ENUM_ICON\
};
#undef X


@implementation SideMenuV
{
    CGRect          closedFrame;
    CGRect          openedFrame;
    UIButton        * menuBtn;
    UIBezierPath    * maskPath;
    CAShapeLayer    * maskLayer;
    
    UIScrollView    * menuSV;
    UIImageView     * imgV;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithMinFrame:(CGRect)minFrame andMaxFrame: (CGRect) maxFrame {
    self = [super initWithFrame:minFrame];
    if (self) {
        closedFrame = minFrame;
        openedFrame = maxFrame;
    }
    return self;
}

- (void) setIcon:(selectedIcon)icon {
    _icon = icon;
    [self setupView];
}

- (void) setupView {
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
                                                          cornerRadii:CGSizeMake(self.frame.size.height / 2.0, self.frame.size.height / 2.0)];
    
    maskLayer    = [CAShapeLayer layer];
    maskLayer.frame             = self.bounds;
    maskLayer.path              = maskPath.CGPath;
    self.layer.mask             = maskLayer;
    self.backgroundColor        = [UIColor whiteColor];
    
    // imgV
    imgV    = [UIImageView new];
    imgV.image  = [UIImage imageNamed:enumAsString[MenuBg]];
    imgV.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:imgV];
    [self addConstraintWithFormat:@"H:|[v0(400)]" views:imgV, nil];
    [self addConstraintWithFormat:@"V:|[v0]|" views:imgV, nil];
    
    // menuBtn
    // Expand and Close SideMenu
    menuBtn                     = [UIButton new];
    menuBtn.translatesAutoresizingMaskIntoConstraints = false;
    menuBtn.tag                 = 0 ;// 0 => normal img, 1 => flipped img
    [menuBtn setBackgroundImage:[UIImage imageNamed:enumAsString[_icon]]
                       forState:UIControlStateNormal];
    [menuBtn addTarget:self
                action:@selector(menuBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [menuBtn addConstraint:[NSLayoutConstraint
                            constraintWithItem:menuBtn
                            attribute:NSLayoutAttributeWidth
                            relatedBy:NSLayoutRelationEqual
                            toItem:menuBtn
                            attribute:NSLayoutAttributeHeight
                            multiplier:1.0
                            constant:0]];
    
    [self addSubview:menuBtn];
    [self addConstraintWithFormat:@"H:|-[v0]"
                            views:menuBtn, nil];
    [self addConstraintWithFormat:@"V:|-(8)-[v0]-(8)-|"
                            views:menuBtn, nil];
    
    // menuList
    // holds the btns that directs to other pages
}



- (void) menuBtnClicked:(UIButton *) btn {
    // Animation
    /*
     The block definition creates a new scope which seems to interfere with the compiler's ability to correctly interpret the switch statement.
     
     Adding scope delimiters for each case label resolves the error. I think this is because the block's scope is now unambiguously a child of the case scope.
     */
    
    switch (btn.tag) {
        case 0:
        {
            [UIView animateWithDuration:0.2f animations:^{
                
                /*
                 WHY NOT USING DISPATCH_ASYNC
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                 
                 });
                 
                 The contents of your block are performed on the main thread regardless of where you call [UIView animateWithDuration:animations:]. It's best to let the OS run your animations; the animation thread does not block the main thread -- only the animation block itself.
                 
                 In a very high-level hand-wavy kind of view of this, [UIView animateWithDuration:animations:] evaluates your block and determines functions for each animatable value within it. The OS has an animation thread that it uses as its frame timer, then at each tick it sends an update on the main thread to your animatable properties with their progressing values. (You can check the current state of these values on your presentationLayer.)
                 
                 Also:
                 https://zonble.gitbooks.io/kkbox-ios-dev/threading/gcd.html
                 
                 */
                
                self.frame = (CGRect) {openedFrame.origin.x, self.frame.origin.y,openedFrame.size};
                
                /* FIXED: By using Width as animation, the UIView will strink/expand into that size without much of animation occur.
                 
                [self setWidth:openedFrame.size.width];
                 
                 FIXED:
                 It seems by setting the background image of UIButton, the layout will be redrawn, thus causing the UIView to sized then show the animation = = 
                 
                 Alternative (I haven't tried yet) is to set the SideMenuV the size you wish for in the opened form and simply move the origin instead of changing the frame
                 
                 */
                
                
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
                                                       cornerRadii:CGSizeMake(self.frame.size.height / 2.0, self.frame.size.height / 2.0)];
                
                maskLayer.frame             = self.bounds;
                maskLayer.path              = maskPath.CGPath;
                self.layer.mask             = maskLayer;
                
                
            } completion:^(BOOL finished) {
                self.frame = (CGRect) {openedFrame.origin.x, self.frame.origin.y,openedFrame.size};
                
                menuBtn.tag     = 1;
            }];
            
            break;
        }
        default:
        {
            [UIView animateWithDuration:0.2f animations:^{
                
                self.frame = (CGRect) {closedFrame.origin.x, self.frame.origin.y,self.frame.size};
                
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
                                                       cornerRadii:CGSizeMake(self.frame.size.height / 2.0, self.frame.size.height / 2.0)];
                
                maskLayer.frame             = self.bounds;
                maskLayer.path              = maskPath.CGPath;
                self.layer.mask             = maskLayer;
                
                
            } completion:^(BOOL finished) {
                
                self.frame = (CGRect) {closedFrame.origin.x, self.frame.origin.y,closedFrame.size};
                
                menuBtn.tag     = 0;
            }];
        }
            break;
    }
    
}

@end
