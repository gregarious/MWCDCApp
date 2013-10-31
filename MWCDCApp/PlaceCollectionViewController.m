//
//  PlaceCollectionViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceCollectionViewController.h"
#import "PlaceViewDataManager.h"
#import "PlaceDataFetcher.h"
#import "PlaceDetailViewController.h"
#import "PlaceTableViewCell.h"
#import "PlaceCategoryMenuViewController.h"
#import "ToggleContainerViewController.h"

#import <MapKit/MapKit.h>

@interface PlaceCollectionViewController ()

- (void)closeModalPicker;

@end

@implementation PlaceCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    // TODO: this kind of sucks. why no init?
    dataManager = [[PlaceViewDataManager alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set up background tap recognizer to clear search bar keyboard when active
    contentAreaTapRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissSearchKeyboard)];
    [contentAreaTapRecognizer setCancelsTouchesInView:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataFetcher.delegate = self;
    [self.dataFetcher fetchPlaces];
    
    self.filterSearchBar.delegate = self;

    // set the filter category if it exists, else use "All Places"
    NSString *buttonTitle = dataManager.filterCategory ? dataManager.filterCategory : @"All Places";
    [self.categoryButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.toggleVC = (ToggleContainerViewController *)segue.destinationViewController;
        self.toggleVC.dataManager = dataManager;
    }
    else if ([[segue identifier] isEqualToString:@"showPlaceDetail"]) {
        PlaceDetailViewController *detailVC = (PlaceDetailViewController *)[segue destinationViewController];
        
        // TODO: shouldn't have to do all the type parsing here. child controllers should process this?
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            // the Place object is the annotation itself
            MKAnnotationView *annotationView = sender;
            Place *place = (Place *)annotationView.annotation;
            [detailVC setPlace:place];
        }
        else if ([sender isKindOfClass:[UITableViewCell class]]) {
            PlaceTableViewCell *cell = (PlaceTableViewCell *)sender;
            PlaceDetailViewController *detailVC = (PlaceDetailViewController *)[segue destinationViewController];
            [detailVC setPlace:cell.place];
        }
    }
    else if ([[segue identifier] isEqualToString:@"showCategoryMenu"]) {
        self.menuVC = (PlaceCategoryMenuViewController *)segue.destinationViewController;
        self.menuVC.categories = @[@"All Places", @"Food", @"Drink", @"Shopping", @"Other"];
        self.menuVC.selectedCategory = dataManager.filterCategory ? dataManager.filterCategory : @"All Places";
        self.menuVC.delegate = self;
    }
}

- (IBAction)toggleViews:(id)sender {
    [self.toggleVC swapViewControllers];

    // would be nice to tie this directly to the active child in the ToggleContainerVC #refactor
    if ([self.displayModeToggleButton.title isEqualToString:@"Map"]) {
        self.displayModeToggleButton.title = @"List";
    }
    else {
        self.displayModeToggleButton.title = @"Map";
    }
}

#pragma mark - PlaceDataFetcherDelegate protocol methods

- (void)fetchingPlacesFailedWithError:(NSError *)error
{
    dataManager.lastError = error;
    // notify subviews of changes
}

- (void)didReceivePlaces:(NSArray *)places
{
    dataManager.places = places;
    dataManager.lastError = nil;
    // notify subviews of changes
}

#pragma mark - UISearchBarDelegate protocol
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    dataManager.filterQuery = searchText;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // enable dismissal of the keyboard while blocking content area interaction
    [self.containerView addGestureRecognizer:contentAreaTapRecognizer];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    // free content area to receive taps again
    [self.containerView removeGestureRecognizer:contentAreaTapRecognizer];
    return YES;
}

- (void)dismissSearchKeyboard
{
    [self.filterSearchBar resignFirstResponder];
}

#pragma mark - Category picker related
- (void)didCancel
{
    [self closeModalPicker];
}

- (void)didPickCategory:(NSString *)category
{
    if ([category isEqualToString:@"All Places"]) {
        dataManager.filterCategory = nil;
    }
    else {
        dataManager.filterCategory = category;
    }
    
    [self.categoryButton setTitle:category forState:UIControlStateNormal];
    
    [self closeModalPicker];
}

#pragma mark - Private methods

- (void)closeModalPicker
{
    // TODO: what is better way to do this?
    [[[self presentedViewController] presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
}

@end
