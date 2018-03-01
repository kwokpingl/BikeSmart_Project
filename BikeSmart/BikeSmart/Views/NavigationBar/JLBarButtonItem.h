//
//  JLBarButtonItem.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/11.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentNavigationBar.h"
#import "UIImage+JLImage.h"

typedef NS_ENUM(NSUInteger, NavigationBarButtonTypes){
    NavigationBarButton_Menu,
    NavigationBarButton_Reload,
    
};

@interface JLBarButtonItem : UIBarButtonItem
- (instancetype)initWithImage:(UIImage *)image
                        style:(UIBarButtonItemStyle)style
                       target:(id)target
                       action:(SEL)action
                resizedToSize:(CGSize) size;
@end
