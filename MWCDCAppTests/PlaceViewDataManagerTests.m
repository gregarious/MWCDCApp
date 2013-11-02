//
//  PlaceViewDataSourceTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Place.h"
#import "PlaceViewDataManager.h"
#import "PlaceTableViewCell.h"

@interface PlaceViewDataManagerTests : XCTestCase
{
    PlaceViewDataManager *dataManager;
    Place *grill;
    Place *bakery;
    NSArray *samplePlaces;
}
@end

@implementation PlaceViewDataManagerTests

- (void)setUp
{
    [super setUp];
    dataManager = [[PlaceViewDataManager alloc] init];
    grill = [[Place alloc] initWithName:@"Shiloh Grill"
                                       streetAddress:@"123 Shiloh St."
                                          coordinate:CLLocationCoordinate2DMake(40, -80)];
    grill.categoryId = 1;
    grill.categoryLabel = @"Restaurants";
    
    bakery = [[Place alloc] initWithName:@"Grandview Bakery"
                           streetAddress:@"215 Shiloh St."
                              coordinate:CLLocationCoordinate2DMake(40, -80)];
    bakery.categoryId = 2;
    bakery.categoryLabel = @"Sweets";

    
    samplePlaces = @[grill, bakery];
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
    dataManager.places = samplePlaces;
    XCTAssertEqual([dataManager dataStatus],
                   PlaceViewDataStatusInitialized,
                   @"should report initialized state if error was set");
}

- (void)testUnfilteredDisplayedPlacesIsNotFiltered
{
    dataManager.places = samplePlaces;
    XCTAssertTrue([[dataManager displayPlaces] isEqualToArray:samplePlaces],
                   @"should not filter if no fitler query is in place");
}

- (void)testEmptyStringQueryDoesNotFilterDisplayPlaces
{
    dataManager.places = samplePlaces;
    dataManager.filterQuery = @"";
    XCTAssertTrue([[dataManager displayPlaces] isEqualToArray:samplePlaces],
                  @"should not filter if no fitler query is in place");
}

- (void)testDisplayPlacesRespectsFilterForName
{
    dataManager.places = samplePlaces;
    dataManager.filterQuery = @"bakery";
    XCTAssertTrue([[dataManager displayPlaces] isEqualToArray:@[bakery]],
                  @"should return place if list is set");
}

- (void)testDisplayPlacesRespectsFilterIfQuerySetBeforePlaces
{
    dataManager.filterQuery = @"bakery";
    dataManager.places = @[grill, bakery];
    XCTAssertTrue([[dataManager displayPlaces] isEqualToArray:@[bakery]],
                  @"should not filter if no fitler query is in place");
}

- (void)testFilterCategoriesAreCorrect
{
    dataManager.places = samplePlaces;
    
    NSArray *categories = dataManager.availableCategories;
    XCTAssertEqual(categories.count, (NSUInteger)2, @"should only have 2 categories");
    
    XCTAssertNotNil(categories);
    XCTAssertTrue([categories indexOfObject:@"Restaurants"] != NSNotFound, @"'Restaurants' should be a category");
    XCTAssertTrue([categories indexOfObject:@"Sweets"] != NSNotFound, @"'Sweets' should be a category");
}


- (void)testDisplayPlacesRespectsCategory
{
    dataManager.places = @[grill, bakery];
    dataManager.filterCategory = @"Sweets";
    XCTAssertTrue([[dataManager displayPlaces] isEqualToArray:@[bakery]],
                  @"should filter out non-category matches");

}

@end
