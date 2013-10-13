//
//  PlaceTableViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "PlaceViewDataManager.h"
#import "PlaceDetailViewController.h"
#import "PlaceDataFetcher.h"
#import "PlaceTableViewCell.h"
#import "Place.h"

@interface PlaceTableViewController ()

- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place;

@end

@implementation PlaceTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // other init
    }
    return self;
}

#pragma mark - View management

- (void)awakeFromNib {
    dataManager = [[PlaceViewDataManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataFetcher.delegate = self;
    [self.dataFetcher fetchPlaces];
    
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);

    if (dataManager.dataStatus == PlaceViewDataStatusInitialized) {
        return [dataManager.places count];
    }
    else {
        return 1;
    }
}

NSString * const placeCellReuseIdenitifier = @"Place";
NSString * const errorCellReuseIdenitifier = @"PlaceError";
NSString * const loadingCellReuseIdenitifier = @"PlaceLoading";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceViewDataStatus status = dataManager.dataStatus;
    if (status == PlaceViewDataStatusInitialized) {
        PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellReuseIdenitifier];
        Place *place = [dataManager placeForPosition:[indexPath row]];
        [self initializeCell:cell withPlace:place];
        return cell;
    }
    else if (status == PlaceViewDataStatusError) {
        NSError *err = [dataManager lastError];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:errorCellReuseIdenitifier];
        cell.textLabel.text = [err localizedDescription];
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:errorCellReuseIdenitifier];
        cell.textLabel.text = @"Loading places...";
        return cell;
    }
}

#pragma mark - PlaceDataFetcherDelegate protocol methods

- (void)fetchingPlacesFailedWithError:(NSError *)error
{
    dataManager.lastError = error;
    [self.tableView reloadData];
}

- (void)didReceivePlaces:(NSArray *)places
{
    dataManager.places = places;
    dataManager.lastError = nil;
    [[self tableView] reloadData];
}

#pragma mark - segue relations

// untested
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPlaceDetail"]) {
        PlaceTableViewCell *cell = (PlaceTableViewCell *)sender;
        PlaceDetailViewController *detailVC = (PlaceDetailViewController *)[segue destinationViewController];
        [detailVC setPlace:cell.place];
    }
}

#pragma mark - Private methods

// untested
- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place
{
    cell.place = place;
    cell.nameLabel.text = place.name;
}

@end
