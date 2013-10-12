//
//  PlaceTableViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "PlaceTableViewController.h"
#import "PlaceDetailViewController.h"
#import "PlaceTableDataSource.h"
#import "PlaceDataFetcher.h"
#import "Place.h"
#import "PlaceTableViewCell.h"

#import "OCMock/OCMock.h"


/* extra methods on VC to access private variables */
@implementation PlaceTableViewController (Inspectable)

- (PlaceTableDataSource *)getTableDataSource {
    return tableDataSource;
}

- (void)setTableDataSource:(PlaceTableDataSource *)dataSource {
    tableDataSource = dataSource;
}


@end

@interface PlaceTableViewControllerTests : XCTestCase
{
    PlaceTableViewController *vc;
    UITableView *tableView;
    UINavigationController *navController;
    
    id mockManager;
    id mockDataSource;
}
@end

@implementation PlaceTableViewControllerTests

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    vc = [storyboard instantiateViewControllerWithIdentifier:@"PlaceTableViewController"];
    navController = [[UINavigationController alloc] initWithRootViewController:vc];

    tableView = [[UITableView alloc] init];
    vc.tableView = tableView;
//    
//    MockPlaceFetchConfiguration *config = [[MockPlaceFetchConfiguration alloc] init];
//    vc.fetchConfiguration = config;
    
//    // the mock config always returns the same manager instance so we can use this to spy
//    mockManager = config.dataManager;
    
    // used in some tests below
    mockDataSource = [OCMockObject mockForClass:[PlaceTableDataSource class]];
}

- (void)tearDown
{
    mockDataSource = nil;
    tableView = nil;
    vc = nil;
    navController = nil;
    
    [super tearDown];
}

#pragma mark - View load behavior

- (void)testDataSourceIsSetAfterViewLoads
{
    [vc setTableDataSource:mockDataSource];
    [vc viewDidLoad];
    XCTAssertEqual(mockDataSource,
                   [[vc tableView] dataSource],
                   @"Should set dataSource when view loads");
}

#pragma mark - View appearance behavior

- (void)testTableDataSourceConnectedAfterAwakeFromNib
{
    [vc awakeFromNib];
    XCTAssertNotNil([vc getTableDataSource],
                    @"should create a table data source when view appears");
}

- (void)testFetchBeginsWhenViewAppears
{
    // test that delegate is set to self and fetching begins
    [[mockManager expect] setDelegate:vc];
    [[mockManager expect] fetchPlaces];
    
    [vc viewWillAppear:NO];
    [mockManager verify];
}

- (void)testDataSourceIsNotifiedAfterFetchError
{
    NSError *err = [NSError  errorWithDomain:@"FakeDomain" code:0 userInfo:nil];
    
    [vc setTableDataSource:mockDataSource];
    [[mockDataSource expect] setLastError:err];

    [vc fetchingPlacesFailedWithError:err];
    [mockDataSource verify];
}

- (void)testTableReloadsAfterFetchError
{
    id mockTableView = [OCMockObject partialMockForObject:vc.tableView];
    vc.tableView = mockTableView;
    
    [[mockTableView expect] reloadData];
    
    [vc fetchingPlacesFailedWithError:nil];
    [mockTableView verify];
}

- (void)testDataSourceGetPlacesAfterFetchSuccess
{
    NSArray *places = [NSArray array];

    [vc setTableDataSource:mockDataSource];
    [[mockDataSource expect] setPlaces:[OCMArg any]];
    [[mockDataSource expect] setLastError:nil];
    
    [vc didReceivePlaces:places];
    [mockDataSource verify];
}

- (void)testTableReloadsAfterFetchSuccess
{
    id mockTableView = [OCMockObject partialMockForObject:vc.tableView];
    vc.tableView = mockTableView;
    
    [[mockTableView expect] reloadData];
    
    [vc didReceivePlaces:nil];
    [mockTableView verify];
}

- (void)testDetailControllerGetsPlaceAfterSegue
{
    PlaceDetailViewController *detailVC = [[PlaceDetailViewController alloc] init];
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"showPlaceDetail"
                                                               source:vc
                                                          destination:detailVC
                                                       performHandler:^{}];
    
    PlaceTableViewCell *cell = [[PlaceTableViewCell alloc] initWithStyle:0 reuseIdentifier:@""];
    Place *samplePlace = [[Place alloc] init];
    cell.place = samplePlace;
    
    [vc prepareForSegue:segue sender:cell];
    XCTAssertEqualObjects([detailVC place],
                          samplePlace,
                          @"should hand the detail VC a place");
}

@end