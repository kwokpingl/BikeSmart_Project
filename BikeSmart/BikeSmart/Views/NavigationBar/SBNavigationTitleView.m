//
//  SBNavigationTitleView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/21.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SBNavigationTitleView.h"

@interface SBNavigationTitleView()
@property (nonatomic) UIImageView   *statusImageView;
@property (nonatomic) UILabel       *statusLabel;
@property (nonatomic) NSLayoutConstraint *imageViewCenterY, *imageViewLeading;
@property (nonatomic) CurrentStatus status;
@property (nonatomic) NSMutableAttributedString *attributedStr;
@end

@implementation SBNavigationTitleView

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    _statusLabel.layer.cornerRadius = _statusLabel.frame.size.height / 2.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.clipsToBounds = true;
        
        [self setupVariable];
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)didMoveToWindow {
    if (self.window == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:Notification_UserStatusChanged object:nil];
        [self statusSet];
    }
}

- (void)setupVariable {
    _status = Status_None;
}

- (void)setupUI {
    _statusImageView = [UIImageView new];
    _statusImageView.translatesAutoresizingMaskIntoConstraints = false;
    _statusImageView.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _statusLabel = [UILabel new];
    _statusLabel.translatesAutoresizingMaskIntoConstraints = false;
    _statusLabel.layoutMargins = UIEdgeInsetsMake(-5, -5, -5, -5);
    _statusLabel.layer.masksToBounds = true;
    _statusLabel.numberOfLines = 0;
    
    [self addSubview:_statusImageView];
    [self addSubview:_statusLabel];
}

- (void)setupConstraints {
    // Image Constraints
    NSLayoutConstraint *imageRatio = [NSLayoutConstraint constraintWithItem:_statusImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_statusImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]; // 1:1
    NSLayoutConstraint *imageCenterY = [NSLayoutConstraint constraintWithItem:_statusImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]; // Centered Y-axis
    NSLayoutConstraint *imageSide = [NSLayoutConstraint constraintWithItem:_statusImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]; // Same Height
    
    [self addConstraints:@[imageRatio, imageCenterY, imageSide]];
    
    // Label Constraints
    NSLayoutConstraint *labelTrailing = [NSLayoutConstraint constraintWithItem:_statusLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]; // Trailing = Trailing
    NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:_statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];  // Centered Y-Axis
    NSLayoutConstraint *labelHeight = [NSLayoutConstraint constraintWithItem:_statusLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//    NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:_statusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    [self addConstraints:@[labelTrailing, labelHeight, labelCenterY]];
    
    // Image-Label Constraints
    NSLayoutConstraint *imageLabelMargin = [NSLayoutConstraint constraintWithItem:_statusImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_statusLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-10.0];
    
    [self addConstraint:imageLabelMargin];
    
    // Adjustable Constraints
    _imageViewCenterY = [NSLayoutConstraint constraintWithItem:_statusImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    _imageViewLeading = [NSLayoutConstraint constraintWithItem:_statusImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10];
    
    [self addConstraint:_imageViewLeading];
    [self addConstraint:_imageViewCenterY];
    
    [_imageViewLeading setActive:false];
}

#pragma mark - NOTIFICATIONs
- (void)statusChanged:(NSNotification *) notification {
    NSDictionary *info = notification.userInfo;
    if (info[Notification_UserStatusChangedKey]!= nil) {
        int statusRawValue = [info[Notification_UserStatusChangedKey] intValue];
        _status = (CurrentStatus) statusRawValue;
        [self statusSet];
    }
}

#pragma mark - FUNCTIONs
- (void)statusSet {
    
    UIImage *image = [ImageUtil getNavigationStatusImage:(NavigationStatus) _status];
    _statusImageView.image = image;
    
    NSString *text;
    switch (_status) {
        case Status_None:
            [_imageViewLeading setActive:false];
            [_imageViewCenterY setActive:true];
            text = @"";
            break;
        case Status_Recording:
            [_imageViewLeading setActive:true];
            [_imageViewCenterY setActive:false];
            text = @"Recording";
            break;
        case Status_Fetching:
            [_imageViewLeading setActive:true];
            [_imageViewCenterY setActive:false];
            text = @"Fetching Data jlkdsjlkflsjflksjlkjdlkjflkdjflksjlk";
            break;
        case Status_Saving:
            [_imageViewLeading setActive:true];
            [_imageViewCenterY setActive:false];
            text = @"Saving Data";
            break;
        case Status_Pause:
            [_imageViewLeading setActive:true];
            [_imageViewCenterY setActive:false];
            text = @"Paused";
    }
    
    [self statusLabelAnimate:@""];
    [self statusLabelAnimate:text];
    [self setNeedsLayout];
}

- (void)statusLabelAnimate:(NSString *)text {
    __weak SBNavigationTitleView *_self = self;
    if ([text isEqualToString:@""]){
        [UIView animateWithDuration:0.25 animations:^{
            [_self.statusLabel offSetYBy:_self.frame.size.height];
        } completion:nil];
    } else {
        _statusLabel.text = text;
        [UIView animateWithDuration:0.25 animations:^{
            [_self.statusLabel offSetYBy:-_self.frame.size.height];
        } completion:nil];
    }
}

@end
