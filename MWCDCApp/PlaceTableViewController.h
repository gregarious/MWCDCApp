//
//  PlaceTableViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDataManagerDelegate.h"

@class PlaceTableDataSource;
@class PlaceDataManager;
@class PlaceFetchConfiguration;

@interface PlaceTableViewController : UITableViewController <PlaceDataManagerDelegate>
{
    PlaceDataManager *dataManager;
    PlaceTableDataSource *tableDataSource;
}

@property (nonatomic, strong) PlaceFetchConfiguration *fetchConfiguration;

@end
