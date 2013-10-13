//
//  PlaceTableDataSourceTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Place.h"
#import "PlaceViewDataManager.h"
#import "PlaceTableViewCell.h"

@interface PlaceTableDataSourceTests : XCTestCase
{
    PlaceViewDataManager *dataManager;
    Place *samplePlace;
}
@end

@implementation PlaceTableDataSourceTests

- (void)setUp
{
    [super setUp];
    dataManager = [[PlaceViewDataManager alloc] init];
    samplePlace = [[Place alloc] initWithName:@"Shiloh Grill"
                                       streetAddress:@"123 Shiloh St."
                                          coordinate:CLLocationCoordinate2DMake(40, -80)];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testUninitializedStateIfNoPlacesOrErrorSet
{
    XCTAssertEqual([dataManager dataStatus],
                   PlaceViewDataStatusUninitialized,
                   @"should report uninitialized state if no error or places is set yet");
}

- (void)testErrorStateIfErrorSet
{
    dataManager.lastError = [NSError errorWithDomain:@"FakeDomain" code:0 userInfo:nil];
    XCTAssertEqual([dataManager dataStatus],
                   PlaceViewDataStatusError,
                   @"should report error state if error was set");
}

- (void)testInitializedStateIfPlacesSet
{
    dataManager.places = @[samplePlace];
    XCTAssertEqual([dataManager dataStatus],
                   PlaceViewDataStatusInitialized,
                   @"should report initialized state if error was set");
}

- (void)testPlaceReturnedFromPlaceAtPosition
{
    dataManager.places = @[samplePlace];
    XCTAssertEqualObjects([dataManager placeForPosition:0],
                          samplePlace,
                          @"should return place if list is set");
}

- (void)testNilPlaceReturnedFromPlaceAtPositionIfNoneSet
{
    XCTAssertNil([dataManager placeForPosition:0],
                 @"should return nil if places list is not set");
}

@end
