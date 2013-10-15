//
//  PlaceCollectionViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToggleContainerViewController.h"
#import "PlaceDataFetcherDelegate.h"

@class PlaceDataFetcher;
@class PlaceViewDataManager;

@interface PlaceCollectionViewController : UIViewController <PlaceDataFetcherDelegate>
{
    PlaceViewDataManager *dataManager;
}

@property (nonatomic, strong) PlaceDataFetcher *dataFetcher;

@property (nonatomic, weak) ToggleContainerViewController *toggleVC;

- (IBAction)toggleViews:(id)sender;


@end
