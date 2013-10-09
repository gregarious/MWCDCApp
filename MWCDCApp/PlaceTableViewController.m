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

@interface PlaceTableViewController ()

@end

@implementation PlaceTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(userDidSelectPlaceNotification:)
     name:PlaceTableDidReceivePlaceNotification
     object:nil];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:PlaceTableDidReceivePlaceNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)userDidSelectPlaceNotification: (NSNotification *)note {
    PlaceDetailViewController *detailVC = [[PlaceDetailViewController alloc] init];
    Place *selectedPlace = (Place *)[note object];
    [detailVC setPlace:selectedPlace];
    [[self navigationController] pushViewController:detailVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        PlaceDetailViewController *detailVC = (PlaceDetailViewController *)[segue destinationViewController];
        [detailVC setPlace:nil];
    }
}

@end
