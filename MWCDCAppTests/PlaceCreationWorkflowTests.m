//
//  PlaceCreationTests.m
//  MWCDCApp
//
//  Test fixture to test the PlaceDataManager workflow
//
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Place.h"
#import "PlaceDataManager.h"
#import "PlaceDataManagerDelegate.h"
#import "MockPlaceDataManagerDelegate.h"
#import "MockPlaceAPICommunicator.h"
#import "FakePlaceBuilder.h"

@interface PlaceCreationWorkflowTests : XCTestCase {
@private
    PlaceDataManager *mgr;
    MockPlaceDataManagerDelegate *delegate;
    NSError *underlyingError;
    FakePlaceBuilder *fakeBuilder;
    NSArray *placesArray;
}
@end

@implementation PlaceCreationWorkflowTests

- (void)setUp
{
    [super setUp];
    
    // To create places, we need:
    //  1. a PlaceDataManager (PDM) to run the show
    //  2. a delegate for the PDM
    //  3. a PlaceAPICommunicator to hook up to the PDMduh)
    //  4. a PlaceBuilder to build Place objects from JSON

    mgr = [[PlaceDataManager alloc] init];
    delegate = [[MockPlaceDataManagerDelegate alloc] init];
    fakeBuilder = [[FakePlaceBuilder alloc] init];

    mgr.delegate = delegate;
    mgr.placeBuilder = fakeBuilder;
    
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    Place *place = [[Place alloc] init];
    placesArray = @[place];
}

- (void)tearDown
{
    mgr = nil;
    delegate = nil;
    underlyingError = nil;
    
    [super tearDown];
}

// Ensure `fetchPlaces` message gets the communicator
- (void)testAskingForPlacesMeansRequestingData
{
    MockPlaceAPICommunicator *communicator = [[MockPlaceAPICommunicator alloc] init];
    mgr.communicator = communicator;

    [mgr fetchPlaces];
    XCTAssertTrue([communicator wasAskedToFetchPlaces], @"The communicator should be told to fetch data");
}

- (void)testErrorIsReturnedToDelegate
{
    [mgr searchingForPlacesFailedWithError:underlyingError];
    XCTAssertNotNil([delegate fetchError],
                    @"Error should be returned to delegate");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    [mgr searchingForPlacesFailedWithError: underlyingError];
    XCTAssertNotEqualObjects(underlyingError,
                             [delegate fetchError],
                             @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [mgr searchingForPlacesFailedWithError: underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey],
                          underlyingError,
                          @"The underlying error should be available to client code");
}

- (void)testPlaceJSONIsPassedToPlaceBuilder {
    [mgr receivedPlacesJSON: @"Fake JSON"];
    XCTAssertEqualObjects(fakeBuilder.JSON, @"Fake JSON", @"Downloaded JSON is sent to the builder");
    mgr.placeBuilder = nil;
}

-(void)testDelegateNotifiedOfErrorWhenPlaceBuilderFails {
    fakeBuilder.arrayToReturn = nil;
    fakeBuilder.errorToSet = underlyingError;

    [mgr receivedPlacesJSON:@"Fake JSON"];
    XCTAssertNotNil([[[delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey],
                    @"The delegate should have found out about the error");
}

-(void)testDelegateNotNotifiedAboutErrorWhenPlacesReceived {
    fakeBuilder.arrayToReturn = placesArray;
    [mgr receivedPlacesJSON:@"Fake JSON"];
    XCTAssertNil([delegate fetchError], @"No error should be received on success");
}

-(void)testDelegateReceivedPlacesDiscoveredByManager {
    fakeBuilder.arrayToReturn = placesArray;
    [mgr receivedPlacesJSON:@"Fake JSON"];
    XCTAssertEqualObjects([delegate receivedPlaces],
                          placesArray,
                          @"Manager should have sent its places to the delegate");
}

-(void)testEmptyArrayIsPassedToDelegate {
    fakeBuilder.arrayToReturn = [NSArray array];
    [mgr receivedPlacesJSON:@"Fake JSON"];
    XCTAssertEqualObjects([delegate receivedPlaces],
                          [NSArray array],
                          @"Returning an empty array is not an error");
}
@end
