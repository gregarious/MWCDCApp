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

#import "PlaceViewDataManager.h"
#import "PlaceDataFetcher.h"
#import "Place.h"
#import "PlaceTableViewCell.h"

#import "OCMock/OCMock.h"

/** 
 * Untested behavior:
 * - segue responds to "showPlaceDetail" identifier and creates a PlaceDetaiLVC
 *      with the given place
 * - table cells are initialized with a place reference
 * - table cells are initialized with various place attributes for display
 */

/* extra methods on VC to access private variables */
@implementation PlaceTableViewController (Accessible)

- (PlaceViewDataManager *)getDataManager {
    return dataManager;
}
- (void)setDataManager:(PlaceViewDataManager *)newDataManager {
    dataManager = newDataManager;
}

@end

@interface PlaceTableViewControllerTests : XCTestCase
{
    PlaceTableViewController *vc;
    
    id mockDataFetcher;
}
@end

@implementation PlaceTableViewControllerTests

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    vc = [storyboard instantiateViewControllerWithIdentifier:@"PlaceTableViewController"];

    mockDataFetcher = [OCMockObject niceMockForClass:[PlaceDataFetcher class]];
    vc.dataFetcher = mockDataFetcher;
}

- (void)tearDown
{
    mockDataFetcher = nil;
    vc = nil;
    
    [super tearDown];
}

#pragma mark - View appearance behavior

- (void)testTableDataManagerConnectedAfterAwakeFromNib
{
    [vc awakeFromNib];
    XCTAssertNotNil([vc getDataManager],
                    @"should initialize a data manager when view appears");
}

- (void)testFetchBeginsWhenViewAppears
{
    // test that delegate is set to self and fetching begins
    [[mockDataFetcher expect] setDelegate:vc];
    [[mockDataFetcher expect] fetchPlaces];
    
    [vc viewWillAppear:NO];
    [mockDataFetcher verify];
}

#pragma mark - UITableViewDataSource protocol behavior: initialized data manager

- (void)testControllerReturnsRowCountIfInitiaized
{
    id manager = [[PlaceViewDataManager alloc] init];
    [vc setDataManager:manager];
    
    NSArray *places = @[[[Place alloc] init], [[Place alloc] init]];
    [manager setPlaces:places];
    
    XCTAssertEqual([vc tableView:nil numberOfRowsInSection:0],
                   (NSInteger)2,
                   @"should return number of places in data manager");
}

- (void)testControllerDefersToDataManagerForCellContentIfInitialized
{
    id manager = [OCMockObject partialMockForObject:[[PlaceViewDataManager alloc] init]];
    [vc setDataManager:manager];

    NSArray *places = @[[[Place alloc] init], [[Place alloc] init]];
    [manager setPlaces:places];

    [[manager expect] placeForPosition:0];
    [vc tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [manager verify];
}

#pragma mark - UITableViewDataSource protocol behavior: uninitialized data manager
- (void)testControllerReportsOneRowIfDataManagerIsUninitialized
{
    XCTAssertEqual([vc tableView:nil numberOfRowsInSection:0],
                   (NSInteger)1,
                   @"should return single row if uninitialized (status cell)");
}

- (void)testControllerDoesNotDeferToDataManagerForCellContentIfUninitialized
{
    id manager = [OCMockObject partialMockForObject:[[PlaceViewDataManager alloc] init]];
    [vc setDataManager:manager];

    [[manager reject] placeForPosition:0];
    [vc tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - UITableViewDataSource protocol behavior: data manager with error
- (void)testControllerReportsOneRowIfDataManagerHasError
{
    id manager = [[PlaceViewDataManager alloc] init];
    [vc setDataManager:manager];
    [manager setLastError:[NSError errorWithDomain:@"FakeDomain" code:0 userInfo:nil]];

    // set up mock with error
    XCTAssertEqual([vc tableView:nil numberOfRowsInSection:0],
                   (NSInteger)1,
                   @"should return single row if uninitialized (status cell)");
}

- (void)testControllerDefersToDataManagerForCellContentIfError
{
    id manager = [OCMockObject partialMockForObject:[[PlaceViewDataManager alloc] init]];
    [vc setDataManager:manager];
    [manager setLastError:[NSError errorWithDomain:@"FakeDomain" code:0 userInfo:nil]];

    [[manager expect] lastError];
    [vc tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [manager verify];
}

#pragma mark - PlaceViewDataManagerDelegate protocol behavior

- (void)testDataManagerIsNotifiedAfterFetchError
{
    id mockDataManager = [OCMockObject niceMockForClass:[PlaceViewDataManager class]];
    NSError *err = [NSError errorWithDomain:@"FakeDomain" code:0 userInfo:nil];
    
    [vc setDataManager:mockDataManager];

    [[mockDataManager expect] setLastError:err];
    [vc fetchingPlacesFailedWithError:err];
    [mockDataManager verify];
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
    id mockDataManager = [OCMockObject niceMockForClass:[PlaceViewDataManager class]];
    NSArray *places = [NSArray array];
    
    [vc setDataManager:mockDataManager];
    
    [[mockDataManager expect] setPlaces:places];
    [[mockDataManager expect] setLastError:nil];   // also ensure error is reset
    [vc didReceivePlaces:places];
    
    [mockDataManager verify];
}

- (void)testTableReloadsAfterFetchSuccess
{
    id mockTableView = [OCMockObject partialMockForObject:vc.tableView];
    vc.tableView = mockTableView;
    
    [[mockTableView expect] reloadData];
    [vc didReceivePlaces:[NSArray array]];
    
    [mockTableView verify];
}

@end