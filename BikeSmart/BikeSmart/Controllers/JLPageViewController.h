//
//  JLPageViewController.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/19.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLScrollMileStoneView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JLPageViewControllerDelegate, JLPageViewControllerDataSource;


@interface JLPageViewController : UIViewController <JLScrollMileStoneViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<JLPageViewControllerDelegate> delegate;
@property (nonatomic, weak) id<JLPageViewControllerDataSource> dataSource;

@property (nonatomic, readonly) NSArray <__kindof UIViewController *> * viewControllers;

@end

@protocol JLPageViewControllerDelegate <NSObject>

@optional
- (CGRect) pageIndicatorFrameForPageViewController:(JLPageViewController *)pageViewcontroller;

@required

@end

@protocol JLPageViewControllerDataSource <NSObject>

- (nullable UIViewController *)pageViewController:(JLPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
- (nullable UIViewController *)pageViewController:(JLPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end


NS_ASSUME_NONNULL_END
