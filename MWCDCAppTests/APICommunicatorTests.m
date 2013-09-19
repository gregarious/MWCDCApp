//
//  APICommunicatorTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InspectableAPICommunicator.h"
#import "NonNetworkedAPICommunicator.h"
#import "MockPlaceDataManager.h"

@interface APICommunicatorTests : XCTestCase {
    InspectableAPICommunicator *communicator;
    NonNetworkedAPICommunicator *nnCommunicator;
    MockPlaceDataManager *manager;
}

@end

@implementation APICommunicatorTests

- (void)setUp
{
    [super setUp];
    communicator = [[InspectableAPICommunicator alloc] init];
    nnCommunicator = [[NonNetworkedAPICommunicator alloc] init];
    manager = [[MockPlaceDataManager alloc] init];
    nnCommunicator.delegate = manager;
}

- (void)tearDown
{
    [communicator cancelAndDiscardURLConnection];
    communicator = nil;
    nnCommunicator = nil;
    [super tearDown];
}

- (void)testFetchingPlacesCreatesURLConnection
{
    [communicator fetchPlaces];
    XCTAssertNotNil([communicator currentURLConnection], @"Should create a new URL connection for fetching");
}

- (void)testFetchingPlacesURLIsCorrect
{
    [communicator fetchPlaces];
    NSURLConnection *connection = [communicator currentURLConnection];
    XCTAssertEqualObjects([[connection originalRequest] URL],
                          [NSURL URLWithString:@"http://mwcdc.scenable.com/api/places/"],
                          @"Should be connecting to the expected URL");
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

/** Test NSURLConnectionDelegate methods **/

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
    [nnCommunicator fetchPlaces];
    [nnCommunicator connection:nil didReceiveResponse:resp404];
    XCTAssertNotNil([manager fetchError],
                    @"Should relay a 404 error to it's delegate");
}

- (void)testThat200ReturnsNoError
{
    NSHTTPURLResponse *resp200 = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
    [nnCommunicator fetchPlaces];
    [nnCommunicator connection:nil didReceiveResponse:resp200];
    XCTAssertNil([manager fetchError],
                 @"Should relay no error if response is 200 OK");
    
}

- (void)testThatFailedConnectionReturnsErrorToDelegate
{
    [nnCommunicator fetchPlaces];
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:99 userInfo:nil];
    [nnCommunicator connection:nil didFailWithError:error];
    XCTAssertEqualObjects([manager fetchError],
                          error,
                          @"Should relay general connection error to its delegate");
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
    [nnCommunicator fetchPlaces];
    [nnCommunicator setResponseBufferContents:[@"Success!" dataUsingEncoding:NSUTF8StringEncoding]];
    [nnCommunicator connectionDidFinishLoading:nil];
    XCTAssertEqualObjects([manager responseJSON],
                          @"Success!",
                          @"Should relay successful response to delegate");
}


@end
