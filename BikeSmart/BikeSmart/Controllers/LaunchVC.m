//
//  LaunchVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/18.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "LaunchVC.h"

@interface LaunchVC (){
    int pageSelected;
}
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *loadingLabel;
@property (nonatomic) UILabel *detailTitleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) FlipPresentAnimationController *flipPresentAnimationController;
@property (nonatomic) JLScrollMileStoneView *scrollBtnV;
@end

@implementation LaunchVC

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self.view setNeedsLayout];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _scrollBtnV.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
}

- (void) setupUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView * test = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 20)];
    
    _scrollBtnV = [[JLScrollMileStoneView alloc] initWithFrame:test.bounds numberOfMileStone:5 withSpaceBetweenStones:2];
    
    [test addSubview:_scrollBtnV];
    
    [self.view addSubview:test];
}

- (void) btnPressed:(UIButton *) sender {
    [sender setSelected:!sender.selected];
    NSLog(@"PRESSED");
    NSLog(@"IS SELECTED : %d", sender.isSelected);
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    _flipPresentAnimationController = [FlipPresentAnimationController new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s", __FUNCTION__);
    [self goToMainPage];
}


- (void) goToMainPage
{
    SBGrandMasterVC *vc = [SBGrandMasterVC new];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:true completion:nil];
}

//////////////////////////////////
// Data Fetching
//////////////////////////////////

#pragma mark - Data Fetching & Realm Writing
- (void) prepareData
{
//    NSArray *bikeStationTypes = [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultBikeTypeKey];
//    
//    // Connect to Server
//    [[ServerConnector sharedInstance] fetchBikeData:bikeStationTypes completeHandler:^(NSDictionary * _Nullable data, NSError * _Nullable internetError, NSError * _Nullable jsonError, BOOL isSuccess) {
//        
//        
//        if (internetError != nil)
//        {
//            NSLog(@"Error Occured at %s : %@", __FUNCTION__, internetError.localizedDescription);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_loadingLabel setUserInteractionEnabled:true];
//                
//                _loadingLabel.text = [NSString stringWithFormat:@"Error : %ld\n%@\nTap To Reload", internetError.code, internetError.localizedDescription];
//            });
//            return;
//        }
//        
//        if (jsonError != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _loadingLabel.text = @"Error : JSON Unreadable";
//                [_loadingLabel setUserInteractionEnabled:true];
//            });
//            return;
//        }
//        
//        if ([data[SUCCESS_KEY] boolValue])
//        {
//            NSLog(@"SUCCESS");
//            
//            // Write into Realm
//            [RealmUtil updateBikeRealmsWithDictionary:data[DATA_KEY] updateHandler:^(BOOL isLastOne, int percentage) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _loadingLabel.text = [NSString stringWithFormat:@"Loading   ... %d%%", percentage];
//                    
//                    if (isLastOne && percentage == 100)
//                    {
//                        _loadingLabel.text = @"DONE";
//                        // Go to MainVC.m
//                        [self goToMainPage];
//                    }
//                });
//                
//            }];
//            
//        }
//        
//        
//    }];
}

/////////////////////////////////////////
//      Gesture Action
/////////////////////////////////////////
- (void) tapGestureRecognizer:(UITapGestureRecognizer *) recognizer {
    if ([recognizer.view isEqual:_loadingLabel]) {
        _loadingLabel.text = @"Loading ...";
//        [self prepareData];
        [_loadingLabel setUserInteractionEnabled:false];
    }
}


/////////////////////////////////////////
//      Delegates
/////////////////////////////////////////
#pragma mark - Transition Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _flipPresentAnimationController.originFrame = self.view.frame;
    _flipPresentAnimationController.flipDelegate = self;
    [_flipPresentAnimationController setDuration:1.0];
    return _flipPresentAnimationController;
}

- (int)selectedMileStoneIndex {
    return pageSelected;
}


////////////////////////////////////////
//              ACTIONS
///////////////////////////////////////
-(void)didPressedBtn {
    [self goToMainPage];
}



////////////////////////////////////////////////
//      FlipPresentAnimationController Delegate
////////////////////////////////////////////////
#pragma mark - FlipPresentAnimationControllerDelegate
-(VCPresentTransitionTypes)transitionTypeForPresentAnimation {
    return EaseIn;
}








@end
