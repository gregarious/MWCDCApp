//
//  APICommunicatorTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "InspectableAPICommunicator.h"
#import "NonNetworkedAPICommunicator.h"
#import "APICommunicatorDelegate.h"

@interface APICommunicatorTests : XCTestCase {
    InspectableAPICommunicator *communicator;
    NonNetworkedAPICommunicator *nnCommunicator;
    id mockDelegate;
}

@end

@implementation APICommunicatorTests

- (void)setUp
{
    [super setUp];
    communicator = [[InspectableAPICommunicator alloc] init];
    nnCommunicator = [[NonNetworkedAPICommunicator alloc] init];
    mockDelegate = [OCMockObject niceMockForProtocol:@protocol(APICommunicatorDelegate)];
    nnCommunicator.delegate = mockDelegate;
}

- (void)tearDown
{
    [communicator cancelAndDiscardURLConnection];
    mockDelegate = nil;
    communicator = nil;
    nnCommunicator = nil;
    [super tearDown];
}

- (void)testFetchingPlacesURLIsCorrect
{
    [communicator fetchPlaces];
    NSURLConnection *connection = [communicator currentURLConnection];
    XCTAssertEqualObjects([[connection originalRequest] URL],
                          [NSURL URLWithString:@"http://mwcdcappserver-mountwashington.dotcloud.com/api/places/"],
                          @"Should be connecting to the expected URL");
}

- (void)testFetchingOverlookURLIsCorrect
{
    [communicator fetchInterestPoints:1];
    NSURLConnection *connection = [communicator currentURLConnection];
    XCTAssertEqualObjects([[connection originalRequest] URL],
                          [NSURL URLWithString:@"http://mwcdcappserver-mountwashington.dotcloud.com/api/viewpoints/1/"],
                          @"Should be connecting to the expected URL");
}

- (void)testFetchingPlacesCreatesURLConnection
{
    [communicator fetchPlaces];
    XCTAssertNotNil([communicator currentURLConnection], @"Should create a new URL connection for fetching");
}

- (void)testThatNewFetchCreatesNewConnection
{
    [communicator fetchPlaces];
    NSURLConnection *oldConnection = [communicator currentURLConnection];
    [communicator fetchPlaces];
    NSURLConnection *currentConnection = [communicator currentURLConnection];
    XCTAssertFalse([currentConnection isEqual:oldConnection],
                   @"Each fetch call should create a new connection");
}

#pragma mark - NSURLConnectionDelegate methods

- (void)testThatCachingIsDisabled
{
    [communicator fetchPlaces];
    XCTAssertNil([communicator connection:nil willCacheResponse:nil], @"Should not tell the connection to use caching");
}

- (void)testThatBufferIsClearedOnResponseInitialization
{
    [nnCommunicator setResponseBufferContents:[@"contents" dataUsingEncoding:NSUTF8StringEncoding]];
    [nnCommunicator fetchPlaces];
    [nnCommunicator connection:nil didReceiveResponse:nil];
    XCTAssertEqual([[nnCommunicator responseBufferContents] length],
                      (NSUInteger)0,
                      @"Each response initialization should flush the buffer");
}

- (void)testThat404ReturnsErrorToDelegate
{
    NSHTTPURLResponse *resp404 = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:404 HTTPVersion:nil headerFields:nil];
    
    [[mockDelegate expect] fetchingDataFailedWithError:[OCMArg isNotNil]];
    
    [nnCommunicator fetchPlaces];
    [nnCommunicator connection:nil didReceiveResponse:resp404];
    [mockDelegate verify];
}

- (void)testThat200ReturnsNoError
{
    NSHTTPURLResponse *resp200 = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
    
    [[mockDelegate reject] fetchingDataFailedWithError:[OCMArg any]];
    
    [nnCommunicator fetchPlaces];
    [nnCommunicator connection:nil didReceiveResponse:resp200];
    
}

- (void)testThatFailedConnectionReturnsErrorToDelegate
{
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:99 userInfo:nil];

    [[mockDelegate expect] fetchingDataFailedWithError:error];
    
    [nnCommunicator fetchPlaces];
    [nnCommunicator connection:nil didFailWithError:error];
    
    [mockDelegate verify];
}

- (void)testThatReceivedDataIsAddedToBuffer
{
    [nnCommunicator fetchPlaces];
    [nnCommunicator setResponseBufferContents:[@"First post!" dataUsingEncoding:NSUTF8StringEncoding]];
    [nnCommunicator connection:nil didReceiveData:[@"Second post" dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *bufferString = [[NSString alloc] initWithData:[nnCommunicator responseBufferContents]
                                                   encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(bufferString,
                          @"First post!Second post",
                          @"Should append all new data to existing buffer");
}

- (void)testThatFullResponseIsRelayedToDelegate
{
    [[mockDelegate expect] receivedDataJSON:@"Success!"];
    
    [nnCommunicator fetchPlaces];
    [nnCommunicator setResponseBufferContents:[@"Success!" dataUsingEncoding:NSUTF8StringEncoding]];
    [nnCommunicator connectionDidFinishLoading:nil];
    
    [mockDelegate verify];
}


@end
