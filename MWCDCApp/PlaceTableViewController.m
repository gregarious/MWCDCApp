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
#import "PlaceCollectionViewController.h"

@interface PlaceTableViewController ()
{
    BOOL isObservingManagerData;
}
- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place;
- (void)startObservingManagerData;
- (void)stopObservingManagerData;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO: observation start/stop and data initialization feels a little
    //  spaghetti-ish due to the intederminate ordering of the manager setting
    //  and view display. Look into verifying correctness and refactoring
    [super viewWillAppear:animated];
    [self startObservingManagerData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopObservingManagerData];
    [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);

    if (self.dataManager.dataStatus == PlaceViewDataStatusInitialized) {
        return [self.dataManager.displayPlaces count];
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
    PlaceViewDataStatus status = self.dataManager.dataStatus;
    if (status == PlaceViewDataStatusInitialized) {
        NSParameterAssert([indexPath row] < [self.dataManager.displayPlaces count]);
        PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellReuseIdenitifier];
        Place *place = [self.dataManager.displayPlaces objectAtIndex:[indexPath row]];
        [self initializeCell:cell withPlace:place];
        return cell;
    }
    else if (status == PlaceViewDataStatusError) {
        NSError *err = [self.dataManager lastError];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    if (self.dataManager.dataStatus == PlaceViewDataStatusInitialized) {
        // TODO: don't really love the need to create a new cell before doing the segue
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        // TODO: obviously parent.parent is not optimal
        PlaceCollectionViewController *placeCollectionRootVC = (PlaceCollectionViewController *)self.parentViewController.parentViewController;
        [placeCollectionRootVC performSegueWithIdentifier:@"showPlaceDetail" sender:cell];
    }
}


#pragma mark - View syncing to data manager

- (void)setDataManager:(PlaceViewDataManager *)dataManager
{
    // TODO: replace this with some kind of data manager callback?
    _dataManager = dataManager;
    [self.tableView reloadData];
    [self startObservingManagerData];
}

// observe the manager's `displayPlaces` property
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"displayPlaces"]) {
        [self.tableView reloadData];
    }
}

#pragma mark - Private methods

- (void)startObservingManagerData
{
    if (_dataManager != nil && !isObservingManagerData) {
        isObservingManagerData = YES;

        // watch the displayPlaces property
        [_dataManager addObserver:self
                       forKeyPath:@"displayPlaces"
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
    }
}

- (void)stopObservingManagerData
{
    isObservingManagerData = NO;
    [_dataManager removeObserver:self forKeyPath:@"displayPlaces"];
}

- (void)initializeCell:(PlaceTableViewCell *)cell withPlace:(Place *)place
{
    cell.place = place;
    cell.nameLabel.text = place.name;
    cell.addressLabel.text = place.streetAddress;
    cell.thumbnail.imageURL = [NSURL URLWithString:@"http://placehold.it/60x60"];
}

@end
