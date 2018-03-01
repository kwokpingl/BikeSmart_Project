//
//  TutorialVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/14.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TutorialVCDelegate

- (void)didPressedBtn;

@end

@interface TutorialVC : UIViewController

@property (nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) id<TutorialVCDelegate> delegate;

@end
