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


@interface PlaceTableViewControllerTests : XCTestCase
{
    PlaceTableViewController *vc;
}
@end

@implementation PlaceTableViewControllerTests

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    vc = [storyboard instantiateViewControllerWithIdentifier:@"PlaceTableViewController"];
}

- (void)tearDown
{
    vc = nil;
    
    [super tearDown];
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

    [[manager expect] places];
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

    [[manager expect] dataStatus];
    [[manager reject] places];
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

@end