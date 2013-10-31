//
//  PlaceCollectionViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDataFetcherDelegate.h"
#import "PlaceCategoryMenuDelegate.h"

@class PlaceDataFetcher;
@class PlaceViewDataManager;
@class PlaceCategoryMenuViewController;
@class ToggleContainerViewController;

@interface PlaceCollectionViewController : UIViewController <PlaceDataFetcherDelegate, UISearchBarDelegate, PlaceCategoryMenuDelegate>
{
    PlaceViewDataManager *dataManager;
    // used to dismiss keyboard when search bar is active
    UIGestureRecognizer *contentAreaTapRecognizer;
}

@property (nonatomic, strong) PlaceDataFetcher *dataFetcher;
@property (nonatomic, weak) ToggleContainerViewController *toggleVC;
@property (nonatomic, weak)
    PlaceCategoryMenuViewController *menuVC;

@property (weak, nonatomic) IBOutlet UISearchBar *filterSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property (weak, nonatomic) IBOutlet UIControl *containerView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *displayModeToggleButton;

- (IBAction)toggleViews:(id)sender;
- (void)dismissSearchKeyboard;

@end
