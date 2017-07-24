//
//  MainVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "MainVC.h"


@interface MainVC ()
{
    MapV                * mapV;
    SideMenuV           * sideMenuV;
    UISearchController  * searchC;
    UISearchBar         * searchB;
}
@end

@implementation MainVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupView {
    
//    CGRect mapVFrame    = (CGRect) {};
    CGRect screen       = [UIScreen mainScreen].bounds;
    CGFloat width       = self.view.frame.size.width;
    CGFloat height      = self.view.frame.size.height;
    CGFloat statusH     = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect mapVFrame    = (CGRect) {0, statusH, width, height - statusH};
    
    CGRect sideMVMinFrame   = (CGRect) {width - 60, 0,
                                    width * 0.2, 44};
    CGRect sideMVMaxFrame   = (CGRect) {10, 0,
                                    width - 10, 44};
    
    mapV = [[MapV alloc] initWithFrame:mapVFrame];
    mapV.delegate = self;
    [self.view addSubview:mapV];
    
    sideMenuV = [[SideMenuV alloc] initWithMinFrame:sideMVMinFrame andMaxFrame:sideMVMaxFrame];
    [sideMenuV setIcon:BikeBlack];
    sideMenuV.delegate = self;
    sideMenuV.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:sideMenuV];
    
    searchB = [UISearchBar new];
    searchB.delegate = self;
    searchB.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:searchB];
    
    // FIXED: Pass nil to end va_arg(args, UIView *)
    // Also => using metrics, use @() => NSNumber to wrap CGFloat
    NSDictionary * metric_V = [[NSDictionary alloc] initWithObjectsAndKeys:@(statusH), @"statusH", nil];
    
    [self.view addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:|-(statusH)-[v0]-(5)-[v1(44)]"
                              options:NSLayoutFormatDirectionRightToLeft
                              metrics:metric_V
                              views:@{@"v0":searchB, @"v1":sideMenuV}]];
    [self.view addConstraintWithFormat:@"H:|[v0]|"
                                 views:searchB, nil];
    [self.view addConstraintWithFormat:@"H:[v0(>=60@500)]|"
                                 views:sideMenuV, nil];

    self.view.backgroundColor = [UIColor BikeSmart_MainGray];
}

// If there is any alert need to show from MapV
// This delegate will show them, including
// "ASKING for AUTHORIZATION ALWAYS"
- (void)mapV:(UIView *)mapV presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:true completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

@end
