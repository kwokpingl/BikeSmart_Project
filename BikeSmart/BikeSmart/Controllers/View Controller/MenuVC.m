//
//  MenuVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/2.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "MenuVC.h"

static NSString *cellIdentifier = @"cell";

@interface MenuVC ()
@property (nonatomic) UIView *topView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray<NSString *> *dataArray;
@property (nonatomic) NSArray<NSNumber *> *enumArray;
@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariables];
    [self setupUI];
}

- (void) setupVariables {
    _dataArray = @[@"Map",
                   @"Station List",
                   @"History",
                   @"News",
                   @"Events",
                   @"Settings",
                   @"Policy",
                   @"FAQ",
                   @"Feedback"];
    
    _enumArray = @[@(VCType_MAP),
                   @(VCType_LIST),
                   @(VCType_HISTORY),
                   @(VCType_NEWS),
                   @(VCType_EVENTS),
                   @(VCType_SETTINGS),
                   @(VCType_POLICY),
                   @(VCType_FAQ),
                   @(VCType_FEEDBACK)];
}

- (void) setupUI {
    /////////////////////////////////////
    // a UIView with ImageView for now
    ////////////////////////////////////
    _topView = [UIView new];
    [_topView setTranslatesAutoresizingMaskIntoConstraints:false];
    [_topView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgV = [UIImageView new];
    [imgV setTranslatesAutoresizingMaskIntoConstraints:false];
//    [imgV setImage:[ImageUtil getMenuImage:MenuIcon_MAINMENU]];
    
    [_topView addSubview:imgV];
    
    NSLayoutConstraint *imageViewCenterY = [NSLayoutConstraint constraintWithItem:imgV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *imageViewHeight = [NSLayoutConstraint constraintWithItem:imgV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeHeight multiplier:0.9 constant:0];
    NSLayoutConstraint *imageViewRatio = [NSLayoutConstraint constraintWithItem:imgV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imgV attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *imageLeading = [NSLayoutConstraint constraintWithItem:imgV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5];
    [_topView addConstraints:@[imageViewCenterY, imageViewHeight, imageViewRatio, imageLeading]];
    
    
    /////////////////////////////////////
    //      Table View
    /////////////////////////////////////
    _tableView = [UITableView new];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellIdentifier];
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
    
    _tableView.estimatedRowHeight = 44;
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_topView];
    [self.view addSubview:_tableView];
    
    ////////////////////////////////////
    //      Setup Constraints
    ////////////////////////////////////
    NSLayoutConstraint *topViewTop = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
    NSLayoutConstraint *topViewLeading = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5];
    NSLayoutConstraint *topViewHeight = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.2 constant:0];
    NSLayoutConstraint *topViewWidth = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-10];
    NSLayoutConstraint *topViewBottom = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *tableViewLeading = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *tableViewWidth = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
    
    [self.view addConstraints:@[topViewTop, topViewLeading, topViewHeight, topViewWidth, topViewBottom, tableViewLeading, tableViewWidth, tableViewBottom]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLEVIEW DELEGATE
////////////////////////
// TableView Delegate
////////////////////////
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_menuVCDelegate switchToViewController:[_enumArray[indexPath.row] unsignedIntegerValue]];
//    NSLog(@"SELECTED");
}

#pragma mark - TABLEVIEW DATASOURCE
////////////////////////
// TableView DataSource
////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    switch (_enumArray[indexPath.row].unsignedIntegerValue) {
        case VCType_MAP:
            cell.imageView.image = [ImageUtil getMenuImage:MenuIcon_MAP];
            break;
            
        case VCType_LIST:
            cell.imageView.image = [ImageUtil getMenuImage:MenuIcon_STATIONLIST];
            break;
            
        default:
            cell.imageView.image = [ImageUtil getMenuImage:MenuIcon_UNKNOWN];
            break;
    }
    
    cell.textLabel.font = [UIFont JLFontWithStyle:UIFontTextStyleHeadline withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CATransform3D trans = CATransform3DMakeTranslation(0, -cell.frame.size.height * (double)(indexPath.row+1) , 0);
    cell.layer.transform = trans;
    
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.01 * (double)indexPath.row];
    cell.layer.transform = CATransform3DIdentity;
    [UIView commitAnimations];
}

@end
