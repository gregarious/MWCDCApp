//
//  PlaceTableViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewController : UIViewController
// not overriding UITableViewController because we want to separate delegate & dataSource duties

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;

- (void)userDidSelectPlaceNotification: (NSNotification *)note;
    
@end
