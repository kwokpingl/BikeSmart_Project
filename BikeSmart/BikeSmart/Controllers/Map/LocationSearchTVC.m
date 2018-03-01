//
//  LocationSearchTVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/29.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "LocationSearchTVC.h"

static NSString *tableViewCellID = @"cellID";

@interface LocationSearchTVC ()

@property (nonatomic) NSArray <MKMapItem *> *matchingItems;

@end

@implementation LocationSearchTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _matchingItems = [NSArray new];
    [self.tableView registerClass:[LocationItemCell class] forCellReuseIdentifier:tableViewCellID];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 20;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _matchingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    
    MKMapItem *item = _matchingItems[indexPath.row];
    
    [cell setMapItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_locationDelegate placeSelected:[cell returnPlacemark]];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (_matchingItems.count > 0) {
        [_locationDelegate placeSelected:_matchingItems[0].placemark];
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SEARCH RESULT UPDATING
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    UISearchBar *searchBar = searchController.searchBar;
    
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = searchBar.text;
    request.region = _currentRegion;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    __weak LocationSearchTVC *weakSelf = self;
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        if (response != nil) {
            weakSelf.matchingItems = response.mapItems;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
        }
    }];
}

@end
