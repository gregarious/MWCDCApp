//
//  SkylineViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkylineDataStoreDelegate.h"

#import <QuartzCore/QuartzCore.h>

@class Overlook;
@class SkylineDataStore;
@class SkylineView;

typedef NS_ENUM(NSUInteger, SkylineViewDataStatus) {
    SkylineViewDataStatusUninitialized,
    SkylineViewDataStatusInitialized,
    SkylineViewDataStatusError
};

@interface SkylineViewController : UIViewController <SkylineDataStoreDelegate>
{
    SkylineDataStore *dataFetcher;
    SkylineViewDataStatus dataStatus;
}

@property (nonatomic, strong) Overlook *overlook;
@property (weak, nonatomic) IBOutlet UILabel *rotationMessageLabel;

// data status window outlets
@property (weak, nonatomic) IBOutlet UIView *dataStatusView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dataStatusLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *dataStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *dataStatusRetryButton;

- (IBAction)retryDataLoad:(id)sender;


@end
