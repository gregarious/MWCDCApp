//
//  PlaceTableViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDataFetcherDelegate.h"

@class PlaceTableDataSource;
@class PlaceDataFetcher;
@class PlaceFetchConfiguration;

@interface PlaceTableViewController : UITableViewController <PlaceDataFetcherDelegate>
{
    PlaceTableDataSource *tableDataSource;
}

@property (nonatomic, strong) PlaceDataFetcher *dataFetcher;

@end
