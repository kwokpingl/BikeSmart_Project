//
//  BikeStationListCollectionViewCell.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/28.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeStationListCollectionViewCell.h"

static CGFloat sortViewWidthPortion = 0.20;
static CGFloat padding = 5;

@interface BikeStationListCollectionViewCell()
@property (nonatomic) UIImageView *favoriteImageView;
@property (nonatomic) UIView *sortView, *bikeView, *spaceView;

@property (nonatomic) UILabel *sortingPropertyLabel, *stationNameLabel, *bikeNumberLabel, *spaceNumberLabel;

@property (nonatomic) UIButton *favoriteButton;
@property (nonatomic) BOOL isFavorite;
@end

@implementation BikeStationListCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self resetAllUI];
        [self addNeededSubviews];
        [self setupUI];
        
    }
    return self;
}

- (void)resetAllUI {
    _sortView               = [UIView new];
    _sortView.translatesAutoresizingMaskIntoConstraints = false;
    
    _bikeView               = [UIView new];
    _bikeView.translatesAutoresizingMaskIntoConstraints = false;
    
    _spaceView              = [UIView new];
    _spaceView.translatesAutoresizingMaskIntoConstraints = false;
    
    // LABELs
    _sortingPropertyLabel   = [UILabel new];
    _sortingPropertyLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    _stationNameLabel       = [UILabel new];
    _stationNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    _bikeNumberLabel        = [UILabel new];
    _bikeNumberLabel.translatesAutoresizingMaskIntoConstraints = false;
    _spaceNumberLabel       = [UILabel new];
    _spaceNumberLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    // BUTTONs
    _favoriteButton = [UIButton new];
    _favoriteButton.translatesAutoresizingMaskIntoConstraints = false;
}

- (void)addNeededSubviews {
    [self addSubview:_stationNameLabel];
    
    [_sortView addSubview:_sortingPropertyLabel];
    [self addSubview:_sortView];
    
    [_bikeView addSubview:_bikeNumberLabel];
    [self addSubview:_bikeView];
    
    [_spaceView addSubview:_spaceNumberLabel];
    [self addSubview:_spaceView];
    
    [self addSubview:_favoriteButton];
}

- (void)setupUI {
    // Top MOST from LEFT to RIGTH
    // STATION NAME - (SORTVIEW - BIKEVIEW - SPACEVIEW - FAVORITE) - DETAIL VIEW
    
    
    
    // SORT VIEW
    //  === PROPERTY LABEL
//    _sortingPropertyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    
    NSLayoutConstraint *sortViewPropertyCenterX = [NSLayoutConstraint constraintWithItem:_sortingPropertyLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_sortView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *sortViewPropertyCenterY = [NSLayoutConstraint constraintWithItem:_sortingPropertyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_sortView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *sortPropertyWHRatio = [NSLayoutConstraint constraintWithItem:_sortingPropertyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_sortingPropertyLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *sortPropertyWidth = [NSLayoutConstraint constraintWithItem:_sortingPropertyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:_sortView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [_sortView addConstraints:@[sortViewPropertyCenterX, sortViewPropertyCenterY, sortPropertyWHRatio, sortPropertyWidth]];
    
    //  === SORT VIEW
    NSLayoutConstraint *sortViewTop = [NSLayoutConstraint constraintWithItem:_sortView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding];
    NSLayoutConstraint *sortViewLeft = [NSLayoutConstraint constraintWithItem:_sortView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
    NSLayoutConstraint *sortViewRight = [NSLayoutConstraint constraintWithItem:_sortView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-padding];
    NSLayoutConstraint *sortViewBottom = [NSLayoutConstraint constraintWithItem:_sortView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-padding];
    [self addConstraints:@[sortViewTop, sortViewLeft, sortViewRight, sortViewBottom]];
    
    // FAVORITE BUTTON
    [_favoriteButton addTarget:self action:@selector(triggerFavoriteButton) forControlEvents:UIControlEventTouchUpInside];
    NSLayoutConstraint *favoriteBtnRight = [NSLayoutConstraint constraintWithItem:_favoriteButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
    NSLayoutConstraint *favoriteBtnLeft = [NSLayoutConstraint constraintWithItem:_favoriteButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:padding];
    NSLayoutConstraint *favoriteBtnCenterY = [NSLayoutConstraint constraintWithItem:_favoriteButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_sortView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *favoriteBtnWHRatio = [NSLayoutConstraint constraintWithItem:_favoriteButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_favoriteButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self addConstraints:@[favoriteBtnRight, favoriteBtnLeft, favoriteBtnCenterY, favoriteBtnWHRatio]];
    
    
    // STATION NAME
    _stationNameLabel.numberOfLines = 0;
    NSLayoutConstraint *stationNameTop = [NSLayoutConstraint constraintWithItem:_stationNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:padding];
    NSLayoutConstraint *stationNameWidth = [NSLayoutConstraint constraintWithItem:_stationNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:(1 - sortViewWidthPortion) constant:-2 * padding];
    NSLayoutConstraint *stationNameCenterX = [NSLayoutConstraint constraintWithItem:_stationNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraints:@[stationNameTop, stationNameWidth, stationNameCenterX]];
    
    // BIKE VIEW
    NSLayoutConstraint *bikeViewTop = [NSLayoutConstraint constraintWithItem:_bikeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding];
    NSLayoutConstraint *bikeViewLeft = [NSLayoutConstraint constraintWithItem:_bikeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *bikeViewRight = [NSLayoutConstraint constraintWithItem:_bikeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *bikeViewWHRatio = [NSLayoutConstraint constraintWithItem:_bikeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeWidth multiplier:4/3 constant:0];
    NSLayoutConstraint *cellHeight = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding];
    [self addConstraints:@[bikeViewTop, bikeViewLeft, bikeViewRight, bikeViewWHRatio, cellHeight]];
    
    _bikeNumberLabel.adjustsFontSizeToFitWidth = true;
    NSLayoutConstraint *bikeNumberTop = [NSLayoutConstraint constraintWithItem:_bikeNumberLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeTop multiplier:1.0 constant:padding];
    NSLayoutConstraint *bikeNumberLeft = [NSLayoutConstraint constraintWithItem:_bikeNumberLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
    NSLayoutConstraint *bikeNumberRight = [NSLayoutConstraint constraintWithItem:_bikeNumberLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
    [_bikeView addConstraints:@[bikeNumberTop, bikeNumberLeft, bikeNumberRight]];
    
    
    // SPACE VIEW
    NSLayoutConstraint *spaceViewTop = [NSLayoutConstraint constraintWithItem:_spaceView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stationNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding];
    NSLayoutConstraint *spaceViewLeft = [NSLayoutConstraint constraintWithItem:_spaceView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *spaceViewRight = [NSLayoutConstraint constraintWithItem:_spaceView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_favoriteButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *spaceViewBottom = [NSLayoutConstraint constraintWithItem:_spaceView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bikeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraints:@[spaceViewTop, spaceViewLeft, spaceViewRight, spaceViewBottom]];
    
    _spaceNumberLabel.adjustsFontSizeToFitWidth = true;
    NSLayoutConstraint *spaceNumberTop = [NSLayoutConstraint constraintWithItem:_spaceNumberLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_spaceView attribute:NSLayoutAttributeTop multiplier:1.0 constant:padding];
    NSLayoutConstraint *spaceNumberLeft = [NSLayoutConstraint constraintWithItem:_spaceNumberLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_spaceView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
    NSLayoutConstraint *spaceNumberRight = [NSLayoutConstraint constraintWithItem:_spaceNumberLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_spaceView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
    [_spaceView addConstraints:@[spaceNumberTop, spaceNumberLeft, spaceNumberRight]];
    
}

- (void)setBikeModel:(BikeModel *)bikeModel {
    _bikeModel = bikeModel;
    
    _isFavorite = [_bikeModel isFavorite];
    
    
}

- (void)changeFavoriteButton {
    UIImage *image = [UIImage new];
    
    _isFavorite = [_bikeModel isFavorite];
    
    if (_isFavorite) {
        image = [ImageUtil getOtherImage:Icon_FAVORITE];
    } else {
        image = [ImageUtil getOtherImage:Icon_UNFAVORITE];
    }
    [_favoriteButton setImage:image forState:UIControlStateNormal];
}

- (void)triggerFavoriteButton {
    
    __weak BikeStationListCollectionViewCell *weakSelf = self;
    
    [[BikeModelManager shared] changeFavoriteBikeModel:_bikeModel completeHandler:^(BOOL isCompleted) {
        if (isCompleted) {
            NSLog(@"DONE");
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf changeFavoriteButton];
            });
        }
    }];
    
    
}

@end
