//
//  PlaceTableDataSourceTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Place.h"
#import "PlaceTableDataSource.h"

@interface PlaceTableDataSourceTests : XCTestCase
{
    PlaceTableDataSource *dataSource;
    NSArray *placesList;
    Place *samplePlace;
}
@end

@implementation PlaceTableDataSourceTests

- (void)setUp
{
    [super setUp];
    dataSource = [[PlaceTableDataSource alloc] init];
    samplePlace = [[Place alloc] initWithName:@"Shiloh Grill"
                                       streetAddress:@"123 Shiloh St."
                                          coordinate:CLLocationCoordinate2DMake(40, -80)];
    placesList = @[samplePlace];
    [dataSource setPlaces: placesList];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testZeroTableRowsIfNoPlacesSet
{
    [dataSource setPlaces:nil];
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 0, @"One place should report one row");
}

- (void)testOneTableRowForOnePlace
{
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 1, @"One place should report one row");
}

- (void)testTwoTableRowsForOnePlaces
{
    placesList = @[[[Place alloc] init], [[Place alloc] init]];
    [dataSource setPlaces: placesList];
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 2, @"Two places should report two rows");
}

- (void)testRowCountExpectsOnlyOneSection
{
    XCTAssertThrows([dataSource tableView:nil numberOfRowsInSection:1],
                    @"Should not allow requesting outside of section 0");
}

- (void)testCellCreationExpectsOnlyOneSection
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:path],
                    @"Should not allow requesting outside of section 0");
}

- (void)testCellCreationOnlyCreatesCellsForPlacesItContains
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:path],
                    @"Should not allow requesting rows it doesn't contain");
}

- (void)testCellCreatedContainsPlaceNameAsTextLabel
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [dataSource tableView:nil cellForRowAtIndexPath:path];
    XCTAssertEqualObjects(cell.textLabel.text, @"Shiloh Grill", @"Should return a cell with place name as label");
}

@end
