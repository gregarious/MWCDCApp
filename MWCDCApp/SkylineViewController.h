//
//  SkylineViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkylineDataFetcherDelegate.h"

@class Overlook;
@class SkylineDataFetcher;

typedef NS_ENUM(NSUInteger, SkylineViewDataStatus) {
    SkylineViewDataStatusUninitialized,
    SkylineViewDataStatusInitialized,
    SkylineViewDataStatusError
};

@interface SkylineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SkylineDataFetcherDelegate>
{
    SkylineDataFetcher *dataFetcher;
    NSArray *skylinePoints;
    
    SkylineViewDataStatus dataStatus;
}

@property (nonatomic, strong) Overlook *overlook;

@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITableView *testTableView;

@end
