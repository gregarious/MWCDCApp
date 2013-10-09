//
//  PlaceTableViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewController : UITableViewController

@property (nonatomic, strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;

- (void)userDidSelectPlaceNotification: (NSNotification *)note;
    
@end
