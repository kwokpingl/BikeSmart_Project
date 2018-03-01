//
//  LoadingView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/12.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
{
    UILabel     *_loadingLabel;
    int         _currentPercentage;
    int         _loadingPercentage;
    int         _delta;
    
    NSTimer     *_timer;
    
    CGRect _titleRect;
    CGRect _iconRect;
    CGRect _loadLabelRect;
}
@end

@implementation LoadingView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _loadingPercentage = 0;
        _currentPercentage = 0;
        
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    
    
    
}

//- (void)drawRect:(CGRect)rect {
//    
//}

////////////////////////////////////////
//      METHODs
////////////////////////////////////////

#pragma mark - PRIVATE METHODs
- (void)changeLoadingLabel:(double) deltaPercentage {
    
    _currentPercentage = _currentPercentage + deltaPercentage;
    
    if (_currentPercentage >= _loadingPercentage) {
        [_timer invalidate];
        _currentPercentage  = _loadingPercentage;
    }
    
    _loadingLabel.text = [NSString stringWithFormat:@"%d", _currentPercentage];
}

- (void)startAnimation {
    
    
}


#pragma mark - PUBLIC METHODs
- (void)setLoadingPercentage:(int) loadingPercentage {
    
    [_timer invalidate];
    
    _delta = loadingPercentage - _currentPercentage;
    _loadingPercentage = loadingPercentage;
    
    __weak LoadingView *weakSelf = self;
    
    _timer = [NSTimer timerWithTimeInterval:0.3 repeats:true block:^(NSTimer * _Nonnull timer) {
        
        float interval = ((double)_delta) / 0.3;
        
        [weakSelf changeLoadingLabel:interval];
    }];
}



@end
