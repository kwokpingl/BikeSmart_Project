//
//  JLPageViewController.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/19.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "JLPageViewController.h"

@interface JLPageViewController ()
{
    int _selectedPageIndex;      // Current page in ScrollView
    BOOL _pageIndicatorEnable;
    CGRect _mileStoneFrame;
}

@property (nonatomic) JLScrollMileStoneView *mileStoneView;
@property (nonatomic) UIColor *mileStoneColor;


@end

@implementation JLPageViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupVariables];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat mileStoneY = self.view.frame.size.height * 0.1;
    
    _mileStoneFrame = CGRectMake(0, mileStoneY, self.view.frame.size.width, self.view.frame.size.height * 0.1);
    
    if (_delegate != nil && !CGRectIsNull([_delegate pageIndicatorFrameForPageViewController:self]
                                          )) {
        _mileStoneFrame = [_delegate pageIndicatorFrameForPageViewController:self];
    }
    
//    _mileStoneView = [JLScrollMileStoneView alloc] initWithFrame:_mileStoneFrame numberOfMileStone:<#(int)#> withSpaceBetweenStones:<#(CGFloat)#>
    
}

- (void)setupVariables {
    _pageIndicatorEnable = false;
    _selectedPageIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////
//          DELEGATES
/////////////////////////////////
#pragma mark - JLSCROLLMILESTONEView DELEGATE



#pragma mark - SCROLLVIEW DELEGATE


/////////////////////////////////
//          
/////////////////////////////////


@end
