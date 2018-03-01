//
//  NavigationMenuButton.m
//  BikeSmart
//
//  Created by Jimmy on 2017/9/29.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "NavigationMenuButton.h"


@interface NavigationMenuButton() {
    CGRect _finalFrame;
    __weak UIViewController * _vc;
}

@end


@implementation NavigationMenuButton

- (instancetype)initWithFrame:(CGRect)frame
                setFinalFrame:(CGRect) finalFrame
             onViewController:(UIViewController *) vc{
    self = [super initWithFrame:frame];
    
    if (self) {
        _finalFrame = finalFrame;
        _vc = vc;
    }
    
    return self;
}

- (void) setupUI {
    [self setImage:[ImageUtil getMenuImage:MenuIcon_MAINMENU]
          forState:UIControlStateNormal];
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonPressed {
    
}

@end
