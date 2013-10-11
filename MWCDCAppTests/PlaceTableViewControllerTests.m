//
//  PlaceTableViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PlaceTableViewController.h"
#import "PlaceDetailViewController.h"
#import "PlaceTableDataSource.h"
#import "PlaceDataManager.h"
#import "Place.h"
#import "PlaceFetchConfiguration.h"
#import "OCMock/OCMock.h"

/* extra methods on VC to access private variables */
@implementation PlaceTableViewController (Inspectable)

- (PlaceDataManager *)getDataManager {
    return dataManager;
}

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
    
    id mockDataSource;
}
@end

@implementation PlaceTableViewControllerTests

- (void)setUp
{
    [super setUp];
    vc = [[PlaceTableViewController alloc] init];
    navController = [[UINavigationController alloc] initWithRootViewController:vc];

    tableView = [[UITableView alloc] init];
    vc.tableView = tableView;
    
    vc.fetchConfiguration = [[PlaceFetchConfiguration alloc] init];
    
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

- (void)testDataManagerIsCreatedBeforeViewAppears
{
    [vc viewWillAppear:NO];
    XCTAssertNotNil([vc getDataManager],
                    @"should create a data manager when view appears");
}

- (void)testDataManagerDelegateIsSelfBeforeViewAppears
{
    [vc viewWillAppear:NO];
    XCTAssertEqualObjects([[vc getDataManager] delegate],
                          vc,
                          @"should create a PlaceDataManager and become its delegate");
}

- (void)testDataSourceIsNotifiedAfterFetchError
{
    NSError *err = [NSError  errorWithDomain:@"FakeDomain" code:0 userInfo:nil];
    
    [vc setTableDataSource:mockDataSource];
    [[mockDataSource expect] setLastError:err];

    [vc fetchingPlacesFailedWithError:err];
    [mockDataSource verify];
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

@end