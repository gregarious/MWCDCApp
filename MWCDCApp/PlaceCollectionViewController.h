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
#import "PlaceCategoryPickerDelegate.h"

@class PlaceDataFetcher;
@class PlaceViewDataManager;
@class PlaceCategoryPickerViewController;

@interface PlaceCollectionViewController : UIViewController <PlaceDataFetcherDelegate, UISearchBarDelegate, PlaceCategoryPickerDelegate>
{
    PlaceViewDataManager *dataManager;
}

@property (nonatomic, strong) PlaceDataFetcher *dataFetcher;
@property (nonatomic, weak) ToggleContainerViewController *toggleVC;
@property (nonatomic, weak)
    PlaceCategoryPickerViewController *pickerVC;

@property (weak, nonatomic) IBOutlet UISearchBar *filterSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property (weak, nonatomic) IBOutlet UIControl *containerView;

- (IBAction)toggleViews:(id)sender;
- (void)dismissSearchKeyboard;

@end
