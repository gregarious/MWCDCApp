//
//  PlaceCollectionViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//
//  Class is a ViewController that handles the roles of both a MapViewVC and a
//  TableViewVC, toggling out these view modes based on user request

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "PlaceDataStoreDelegate.h"
#import "PlaceCategoryMenuDelegate.h"

@class PlaceDataStore;
@class PlaceViewDataManager;
@class PlaceCategoryMenuViewController;
@class ToggleContainerViewController;

@class MKMapView;

typedef NS_ENUM(NSInteger, PlaceCollectionViewMode) {
    PlaceCollectionViewModeTable,
    PlaceCollectionViewModeMap
};

@interface PlaceCollectionViewController : UIViewController <
     PlaceDataFetcherStore,                          // respond to async data fetching events
     UISearchBarDelegate, PlaceCategoryMenuDelegate,    // respond to search/filter UI elements
     UITableViewDelegate, UITableViewDataSource,        // respond to typical UITableView events
     MKMapViewDelegate>                                 // respond to typical MKMapView events
{
    PlaceViewDataManager *dataManager;

    UITableView *tableView;
    MKMapView *mapView;
    
    // used to dismiss keyboard when search bar is active
    UIGestureRecognizer *contentAreaTapRecognizer;
}

@property (nonatomic, assign) PlaceCollectionViewMode viewMode;
@property (nonatomic, strong) PlaceDataStore *dataStore;
@property (nonatomic, weak) PlaceCategoryMenuViewController *menuVC;

// holds main view content (also recognizes taps to dismiss search keyboard)
@property (weak, nonatomic) IBOutlet UIControl *contentView;

// outlets related to filtering/searching
@property (weak, nonatomic) IBOutlet UISearchBar *filterSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
// (necessary to tweak for iOS 6 styling)
@property (weak, nonatomic) IBOutlet UIView *filterContainerView;

// data status window outlets
@property (weak, nonatomic) IBOutlet UIView *dataStatusView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dataStatusLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *dataStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *dataStatusRetryButton;

// display mode toggling outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *displayModeToggleButton;

// display mode toggle button aaction
- (IBAction)toggleViews:(id)sender;
- (IBAction)retryDataLoad:(id)sender;

// method used when containerView is tapped to resign first responder status
- (void)dismissSearchKeyboard;

- (void)showDataStatusWithMessage:(NSString *)message showLoadingIndicator:(BOOL)shouldShowLoadingIndicator retryEnabled:(BOOL)shouldEnableRetry;
- (void)hideDataStatus;

@end
