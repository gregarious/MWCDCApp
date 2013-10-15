//
//  SkylineViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylineViewController.h"
#import "Overlook.h"
#import "SkylinePoint.h"
#import "SkylineDataFetcher.h"
#import "InterestPointDetailViewController.h"
#import "TestSkylinePointTableCell.h"

@interface SkylineViewController ()

- (void)reloadData;
- (void)configureViews;

@end

@implementation SkylineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setOverlook:(Overlook *)overlook
{
    _overlook = overlook;
    [self configureViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataFetcher = [SkylineDataFetcher defaultFetcher];
    dataFetcher.delegate = self;
    
    dataStatus = SkylineViewDataStatusUninitialized;
    [self reloadData];
    
    [self configureViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SkylineDataFetcherDelegate methods

- (void)didReceiveSkylinePoints:(NSArray *)points forOverlook:(NSInteger)overlookID
{
    skylinePoints = points;
    dataStatus = SkylineViewDataStatusInitialized;
    [self configureViews];
}

- (void)fetchingSkylinePointsFailedWithError:(NSError *)error
{
    // ignore the error if we already have data
    if (skylinePoints == nil) {
        dataStatus = SkylineViewDataStatusError;
    }
    [self configureViews];
}

#pragma mark - Segue methods

NSString * const interestPointSegueIdentifier = @"showInterestPointDetail";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:interestPointSegueIdentifier]) {
        SkylinePoint *point = [sender skylinePoint];
        InterestPointDetailViewController *detailVC = [segue destinationViewController];
        detailVC.interestPoint = point.interestPoint;
    }
}

#pragma mark - TableView delegate/data source (development only)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    if (dataStatus == SkylineViewDataStatusInitialized) {
        return [skylinePoints count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@""];
    if (dataStatus == SkylineViewDataStatusUninitialized) {
        cell.textLabel.text = @"Loading...";
    }
    else if(dataStatus == SkylineViewDataStatusError) {
        cell.textLabel.text = @"Error!";
    }
    else {
        TestSkylinePointTableCell *skylineCell = [[TestSkylinePointTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SkylineCell"];
        skylineCell.skylinePoint = skylinePoints[indexPath.row];
        skylineCell.textLabel.text = skylineCell.skylinePoint.interestPoint.name;
        cell = skylineCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    if (dataStatus == SkylineViewDataStatusInitialized) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:interestPointSegueIdentifier sender:cell];
    }
}

#pragma mark - Private methods

- (void)reloadData
{
    [dataFetcher fetchSkylinePoints:_overlook._id];
}
- (void)configureViews
{
    self.testLabel.text = _overlook.name;
    [[self testTableView] reloadData];
}

@end
