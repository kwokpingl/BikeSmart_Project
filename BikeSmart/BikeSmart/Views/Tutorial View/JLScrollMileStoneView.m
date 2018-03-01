//
//  ScrollingButtonV.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/18.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "JLScrollMileStoneView.h"

@interface JLScrollMileStoneView()
{
    int _mileStoneNumber;
    CGFloat _mileStoneSpace;
    NSMutableArray<JLScrollMileStoneButton *> *_mileStoneArray;
    NSMutableArray<NSMutableDictionary <NSString *, NSNumber *> *> *_mileStoneFrames;
    NSString *_mileStoneXKey, *_mileStoneYKey, *_mileStoneSideKey;
    UIEdgeInsets _mileStoneInsets;
}

typedef enum : NSUInteger {
    ButtonAlignAlongX,
    ButtonAlignAlongY
} ButtonAlignAlong;

@end

@implementation JLScrollMileStoneView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFrame];
    
    int i = 0;
    
    for (JLScrollMileStoneButton *stone in _mileStoneArray) {
        
        NSMutableDictionary <NSString *, NSNumber *> *dict = _mileStoneFrames[i];
        
        CGFloat mileStoneX = [dict[_mileStoneXKey] doubleValue];
        CGFloat mileStoneY = [dict[_mileStoneYKey] doubleValue];
        CGFloat mileStoneSide = [dict[_mileStoneSideKey] doubleValue];
        
        
        stone.frame = CGRectMake(mileStoneX, mileStoneY, mileStoneSide, mileStoneSide);
        NSLog(@"NEW FRAME : %f, %f, %f", mileStoneX, mileStoneY, mileStoneSide);
        
        [stone setNeedsDisplay];
        [stone setNeedsLayout];
        
        i++;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
            numberOfMileStone:(int) mileStoneNumber
       withSpaceBetweenStones:(CGFloat) space
{
    self = [super initWithFrame:frame];
    if (self) {
        _mileStoneNumber = mileStoneNumber;
        _mileStoneSpace = space;
        [self setupVariable];
        [self setupFrame];
        [self setupUI];
    }
    return self;
}

- (void)setupVariable {
    _mileStoneArray = [NSMutableArray new];
    _mileStoneXKey = @"X";
    _mileStoneYKey = @"Y";
    _mileStoneSideKey = @"Side";
}

- (void)setupFrame {
    
    CGFloat longerLength = self.frame.size.height < self.frame.size.width ?
                        self.frame.size.width : self.frame.size.height;
    
    ButtonAlignAlong along = self.frame.size.height < self.frame.size.width ?
                                ButtonAlignAlongX : ButtonAlignAlongY;
    
    CGFloat mileStoneSide = self.frame.size.height < self.frame.size.width ?
                                self.frame.size.height - 2 * _mileStoneSpace :
                                self.frame.size.width - 2 * _mileStoneSpace;
    
    if (mileStoneSide * (CGFloat)_mileStoneNumber + (CGFloat)(_mileStoneNumber - 1) * _mileStoneNumber> longerLength) {
        mileStoneSide = longerLength / ((CGFloat) _mileStoneNumber) - 2 * _mileStoneSpace;
    }
    
    CGFloat mileStoneLength = mileStoneSide * (CGFloat)_mileStoneNumber + (CGFloat)(_mileStoneNumber - 1) * _mileStoneSpace;
    
    CGFloat emptyLength = (longerLength - mileStoneLength);
    
    CGFloat mileStoneX = self.frame.origin.x;
    CGFloat mileStoneY = self.frame.origin.y;
    
    switch (along) {
        case ButtonAlignAlongX:
            mileStoneX = mileStoneX + emptyLength / 2.0;
            mileStoneY = mileStoneY + _mileStoneSpace;
            break;
        case ButtonAlignAlongY:
            mileStoneX = mileStoneX + _mileStoneSpace;
            mileStoneY = mileStoneY + emptyLength / 2.0;
            break;
    }
    
    _mileStoneInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    _mileStoneFrames = [NSMutableArray new];
    
    for (int i = 0; i < _mileStoneNumber; i++) {
        
        NSMutableDictionary <NSString *, NSNumber *> *dict = [NSMutableDictionary new];
        
        dict[_mileStoneXKey] = @(mileStoneX);
        dict[_mileStoneYKey] = @(mileStoneY);
        dict[_mileStoneSideKey] = @(mileStoneSide);
        
        
        [_mileStoneFrames addObject:dict];
        
        
        switch (along) {
            case ButtonAlignAlongX:
                mileStoneX = mileStoneX + _mileStoneSpace + mileStoneSide;
                break;
            case ButtonAlignAlongY:
                mileStoneY = mileStoneY + _mileStoneSpace + mileStoneSide;
                break;
        }
    }
}

- (void)setupUI {
    for (int i = 0; i < _mileStoneNumber; i++) {
        
        NSMutableDictionary <NSString *, NSNumber *> *dict = _mileStoneFrames[i];
        
        CGFloat mileStoneX = [dict[_mileStoneXKey] doubleValue];
        CGFloat mileStoneY = [dict[_mileStoneYKey] doubleValue];
        CGFloat mileStoneSide = [dict[_mileStoneSideKey] doubleValue];
        
        
        CGRect mileStonFrame = CGRectMake(mileStoneX, mileStoneY, mileStoneSide, mileStoneSide);
        
        JLScrollMileStoneButton *mileStone = [[JLScrollMileStoneButton alloc] initWithFrame:mileStonFrame insets:_mileStoneInsets];
        [_mileStoneArray addObject:mileStone];
        [self addSubview:mileStone];
        
    }
}

@end
