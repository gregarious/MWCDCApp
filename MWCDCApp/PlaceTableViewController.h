//
//  PlaceTableViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDataFetcherDelegate.h"

@class PlaceViewDataManager;
@class PlaceDataFetcher;
@class PlaceFetchConfiguration;
@class PlaceTableViewCell;
@class Place;

@interface PlaceTableViewController : UITableViewController <PlaceDataFetcherDelegate>
{
    PlaceViewDataManager *dataManager;
}

@property (nonatomic, strong) PlaceDataFetcher *dataFetcher;

// private method, made public for simple testing
- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place;

@end
