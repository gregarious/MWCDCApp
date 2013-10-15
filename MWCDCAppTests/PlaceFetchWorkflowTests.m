//
//  PlaceFetchWorkflowTests.m
//  MWCDCApp
//
//  Test fixture to test the PlaceDataFetcher workflow
//
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Place.h"
#import "PlaceDataFetcher.h"
#import "PlaceDataFetcherDelegate.h"
#import "APICommunicator.h"
#import "FakePlaceBuilder.h"


@interface PlaceFetchWorkflowTests : XCTestCase {
@private
    PlaceDataFetcher *fetcher;
    id delegate;
    NSError *underlyingError;
    FakePlaceBuilder *fakeBuilder;
    NSArray *placesArray;
}
@end

@implementation PlaceFetchWorkflowTests

- (void)setUp
{
    [super setUp];
    
    // To create places, we need:
    //  1. a PlaceDataFetcher (PDF) to run the show
    //  2. a delegate for the PDF
    //  3. a PlaceAPICommunicator to hook up to the PDF
    //  4. a PlaceBuilder to build Place objects from PDF

    fetcher = [[PlaceDataFetcher alloc] init];
    delegate = [OCMockObject niceMockForProtocol:@protocol(PlaceDataFetcherDelegate)];
    fakeBuilder = [[FakePlaceBuilder alloc] init];

    fetcher.delegate = delegate;
    fetcher.placeBuilder = fakeBuilder;
    
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    Place *place = [[Place alloc] init];
    placesArray = @[place];
}

- (void)tearDown
{
    fetcher = nil;
    delegate = nil;
    underlyingError = nil;
    
    [super tearDown];
}

#pragma mark - Default fetcher tests

- (void)testDefaultFetcherConfiguresAllComponents
{
    PlaceDataFetcher *defaultFetcher = [PlaceDataFetcher defaultFetcher];
    XCTAssertNotNil(defaultFetcher.communicator);
    XCTAssertNotNil(defaultFetcher.placeBuilder);
}

- (void)testDefaultFetcherSetsCommunicatorDelegateToSelf
{
    PlaceDataFetcher *defaultFetcher = [PlaceDataFetcher defaultFetcher];
    XCTAssertNotNil(defaultFetcher);
    XCTAssertEqualObjects(defaultFetcher.communicator.delegate,
                          defaultFetcher,
                          @"should set communicator delegate to be the fetcher");
}

#pragma mark - Communicator-related tests

// Ensure `fetchPlaces` message gets the communicator
- (void)testAskingForPlacesMeansRequestingData
{
    id communicator = [OCMockObject mockForClass:[APICommunicator class]];
    fetcher.communicator = communicator;

    [[communicator expect] fetchPlaces];
    [fetcher fetchPlaces];
    
    [communicator verify];
}

- (void)testErrorIsReturnedToDelegate
{
    [[delegate expect] fetchingPlacesFailedWithError:[OCMArg isNotNil]];
    [fetcher fetchingDataFailedWithError:underlyingError];
    [delegate verify];
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    // ensure error reported is at the correct level of abstraction
    [[delegate expect] fetchingPlacesFailedWithError:[OCMArg checkWithBlock:^BOOL(id error) {
        return ![error isEqual:underlyingError];
    }]];
    
    [fetcher fetchingDataFailedWithError:underlyingError];
    [delegate verify];
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    // ensure error reported is at the correct level of abstraction
    [[delegate expect] fetchingPlacesFailedWithError:[OCMArg checkWithBlock:^BOOL(id error) {
        NSError *actualUnderlying = [[error userInfo] objectForKey: NSUnderlyingErrorKey];
        return [underlyingError isEqual:actualUnderlying];
    }]];
    
    [fetcher fetchingDataFailedWithError:underlyingError];
    [delegate verify];
}

#pragma mark - Builder-related tests

- (void)testPlaceJSONIsPassedToPlaceBuilder {
    [fetcher receivedDataJSON: @"Fake JSON"];
    XCTAssertEqualObjects(fakeBuilder.JSON, @"Fake JSON", @"Downloaded JSON is sent to the builder");
    fetcher.placeBuilder = nil;
}

-(void)testDelegateNotifiedOfErrorWhenPlaceBuilderFails {
    fakeBuilder.arrayToReturn = nil;
    fakeBuilder.errorToSet = underlyingError;

    [[delegate expect] fetchingPlacesFailedWithError:[OCMArg isNotNil]];
    [fetcher receivedDataJSON:@"Fake JSON"];
    
    [delegate verify];
}

-(void)testDelegateNotNotifiedAboutErrorWhenPlacesReceived {
    fakeBuilder.arrayToReturn = placesArray;
    
    [[delegate reject] fetchingPlacesFailedWithError:[OCMArg any]];
    [fetcher receivedDataJSON:@"Fake JSON"];
    
    [delegate verify];
}

-(void)testDelegateReceivedPlacesDiscoveredByManager {
    fakeBuilder.arrayToReturn = placesArray;
    
    [[delegate expect] didReceivePlaces:placesArray];
    [fetcher receivedDataJSON:@"Fake JSON"];
    
    [delegate verify];
}

-(void)testEmptyArrayIsPassedToDelegate {
    // documents that building an empty array is not an error
    
    NSArray *empty = [NSArray array];
    fakeBuilder.arrayToReturn = empty;
    
    [[delegate expect] didReceivePlaces:empty];
    [fetcher receivedDataJSON:@"Fake JSON"];
    
    [delegate verify];
}
@end
