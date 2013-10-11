//
//  PlaceTableViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "PlaceTableDataSource.h"
#import "PlaceDetailViewController.h"
#import "PlaceFetchConfiguration.h"
#import "PlaceDataManager.h"

@interface PlaceTableViewController ()

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

-(void)awakeFromNib {
    tableDataSource = [[PlaceTableDataSource alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = tableDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    dataManager = [[self fetchConfiguration] dataManager];
    dataManager.delegate = self;

    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        PlaceDetailViewController *detailVC = (PlaceDetailViewController *)[segue destinationViewController];
        [detailVC setPlace:nil];
    }
}

- (void)fetchingPlacesFailedWithError:(NSError *)error
{
    tableDataSource.lastError = error;
}

- (void)didReceivePlaces:(NSArray *)places
{
    tableDataSource.places = places;
    tableDataSource.lastError = nil;
}


@end
