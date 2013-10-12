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
#import "PlaceTableViewCell.h"

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

#pragma mark - Cell access domain assertions

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
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:path],
                    @"Should not allow requesting rows it doesn't contain");
}

#pragma mark - Table cell creation: loading/error states

- (void)testStatusCellShownIfNoDataAndNoError
{
    [dataSource setPlaces:nil];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [dataSource tableView:nil cellForRowAtIndexPath:path];
    XCTAssertEqualObjects(cell.textLabel.text,
                          @"Loading places...",
                          @"should return a loading status cell");
}

- (void)testErrorCellShownIfNoDataAndError
{
    [dataSource setPlaces:nil];
    NSError *err = [NSError errorWithDomain:@"FakeDomain" code:0
                                   userInfo:@{NSLocalizedDescriptionKey: @"Failure accessing places"}];
    [dataSource setLastError:err];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [dataSource tableView:nil cellForRowAtIndexPath:path];
    XCTAssertEqualObjects(cell.textLabel.text,
                          @"Failure accessing places",
                          @"Should return an error cell when an error occurred and there is no data");
}

#pragma mark - Table cell creation: data-backed

- (void)testZeroTableRowsIfZeroPlacesSet
{
    // Note that this is unlikely: this will only happen if the server successfully responds with 0 places.
    // Typically, it will have not yet responded or responded with error, which does display a cell
    [dataSource setPlaces:[NSArray array]];
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 0, @"Empty places should report zero rows");
}

- (void)testOneTableRowForUnsetPlaces
{
    dataSource.places = nil;
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 1, @"Should report one row if places not set (means error/loading is displayed");
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

- (void)testCellCreatedContainsPlace
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    PlaceTableViewCell *cell = (PlaceTableViewCell *)[dataSource tableView:nil cellForRowAtIndexPath:path];
    XCTAssertEqualObjects(cell.place,
                          samplePlace,
                          @"Should return a cell with a reference to the sample place");
}

//- (void)testCellCreatedHasExpectedProperties
//{
//    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//    PlaceTableViewCell *cell = (PlaceTableViewCell *)[dataSource tableView:nil cellForRowAtIndexPath:path];
//    XCTAssertEqualObjects(cell.nameLabel.text,
//                          samplePlace.name,
//                          @"Should correctly set the label");
//}

- (void)testPlaceCellShownIfDataAndError
{
    // ensure the error is ignored if there's good data to show
    NSError *err = [NSError errorWithDomain:@"FakeDomain" code:0
                                   userInfo:@{NSLocalizedDescriptionKey: @"Failure accessing places"}];
    [dataSource setLastError:err];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    PlaceTableViewCell *cell = (PlaceTableViewCell *)[dataSource tableView:nil cellForRowAtIndexPath:path];
    XCTAssertEqualObjects(cell.place,
                          samplePlace,
                          @"Should return place cell over error if data is set");
}


@end
