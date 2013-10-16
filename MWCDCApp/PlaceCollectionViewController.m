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

#import <MapKit/MapKit.h>

@interface PlaceCollectionViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataFetcher.delegate = self;
    [self.dataFetcher fetchPlaces];
    
    self.filterSearchBar.delegate = self;
    
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

}

- (IBAction)toggleViews:(id)sender {
    [self.toggleVC swapViewControllers];
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
@end
