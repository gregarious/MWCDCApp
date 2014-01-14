//
//  SkylineFetchWorkflowTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//
// TODO: These "flow" interaction style tests are crap. See Simplenote notes.
//          Would be great to come back and rewrite them as facade integration
//          tests, and possibly change the delegate callbacks to a blocks.

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "APICommunicator.h"
#import "SkylinePoint.h"
#import "SkylinePointBuilder.h"
#import "SkylineDataStore.h"
#import "SkylineDataStoreDelegate.h"

@interface SkylineFetchWorkflowTests : XCTestCase
{
    SkylineDataStore *fetcher;

    id mockDelegate;
    id mockBuilder;
    
    NSArray *skylinePointArray;
    NSError *underlyingError;
}
@end

@implementation SkylineFetchWorkflowTests

- (void)setUp
{
    [super setUp];
    
    fetcher = [[SkylineDataStore alloc] init];
    
    mockDelegate = [OCMockObject niceMockForProtocol:@protocol(SkylineDataStoreDelegate)];
    fetcher.delegate = mockDelegate;
    mockBuilder = [OCMockObject niceMockForClass:[SkylinePointBuilder class]];
    fetcher.objectBuilder = mockBuilder;

    // stub out the builder's typical response
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];

    skylinePointArray = @[[[SkylinePoint alloc] init]];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Default fetcher tests

- (void)testDefaultFetcherConfiguresAllComponents
{
    SkylineDataStore *defaultFetcher = [SkylineDataStore defaultFetcher];
    XCTAssertNotNil(defaultFetcher.communicator);
    XCTAssertNotNil(defaultFetcher.objectBuilder);
}

- (void)testDefaultFetcherSetsCommunicatorDelegateToSelf
{
    SkylineDataStore *defaultFetcher = [SkylineDataStore defaultFetcher];
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
    
    [[communicator expect] fetchInterestPoints:1];
    [fetcher fetchSkylinePoints:1];
    
    [communicator verify];
}

- (void)testErrorIsReturnedToDelegate
{
    [[mockDelegate expect] fetchingSkylinePointsFailedWithError:[OCMArg isNotNil]];
    [fetcher fetchingDataFailedWithError:underlyingError];
    [mockDelegate verify];
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    // ensure error reported is at the correct level of abstraction
    [[mockDelegate expect] fetchingSkylinePointsFailedWithError:[OCMArg checkWithBlock:^BOOL(id error) {
        return ![error isEqual:underlyingError];
    }]];
    
    [fetcher fetchingDataFailedWithError:underlyingError];
    [mockDelegate verify];
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    // ensure error reported is at the correct level of abstraction
    [[mockDelegate expect] fetchingSkylinePointsFailedWithError:[OCMArg checkWithBlock:^BOOL(id error) {
        NSError *actualUnderlying = [[error userInfo] objectForKey: NSUnderlyingErrorKey];
        return [underlyingError isEqual:actualUnderlying];
    }]];
    
    [fetcher fetchingDataFailedWithError:underlyingError];
    [mockDelegate verify];
}

#pragma mark - Builder-related tests

- (void)testPlaceJSONIsPassedToPlaceBuilder {
    [[mockBuilder expect] dataFromJSON:@"Fake JSON"
                                 error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
    [fetcher receivedDataJSON: @"Fake JSON"];
    [mockBuilder verify];
}

//broken. see notes above.
//-(void)testDelegateReceivedPlacesDiscoveredByManager {
//    [[[mockBuilder stub] andReturn:skylinePointArray] dataFromJSON:@"Fake JSON"
//                                                             error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
//    [[mockDelegate expect] didReceiveSkylinePoints:skylinePointArray forOverlook:1];
//    [fetcher receivedDataJSON:@"Fake JSON"];
//    
//    [mockDelegate verify];
//}
//
//-(void)testEmptyArrayIsPassedToDelegate {
//    // documents that building an empty array is not an error
//    [[[mockBuilder stub] andReturn:[NSArray array]] dataFromJSON:@"Fake JSON"
//                                                           error:(NSError * __autoreleasing *)[OCMArg anyPointer]];
//    
//    [[mockDelegate expect] didReceiveSkylinePoints:[NSArray array] forOverlook:1];
//    [fetcher receivedDataJSON:@"Fake JSON"];
//    
//    [mockDelegate verify];
//}

@end
