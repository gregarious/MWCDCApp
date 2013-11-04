//
//  SkylinePointBuilder.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SkylinePointBuilder.h"
#import "SkylinePoint.h"

@interface SkylinePointBuilderTests : XCTestCase
{
    SkylinePointBuilder *builder;
    NSString *fullJSON;
}
@end

@implementation SkylinePointBuilderTests

- (void)setUp
{
    [super setUp];
    builder = [[SkylinePointBuilder alloc] init];
    fullJSON = @"{\"interest_points\": ["
    @"{"
    @"    \"id\": 1, "
    @"    \"name\": \"U.S. Steel Tower\", "
    @"    \"address\": \"600 Grant Street\", "
    @"    \"description\": \"Big ol' building\", "
    @"    \"image\": \"image.png\","
    @"    \"label\": \"2\", "
    @"    \"x\": 1, "
    @"    \"y\": 1"
    @"}]}";
}

- (void)tearDown
{
    fullJSON = nil;
    builder = nil;
    [super tearDown];
}

#pragma mark - Invalid JSON tests

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([builder dataFromJSON:@"Invalid JSON" error:NULL],
                 @"Unparsable JSON should yield nil.");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    XCTAssertNil([builder dataFromJSON:@"Invalid JSON" error:&error],
                 @"Unparsable JSON should set an error.");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([builder dataFromJSON:@"Invalid JSON"
                                     error:NULL],
                     @"A NULL error parameter should be allowed.");
}

#pragma mark - Invalid, well-formed JSON tests

- (void)testJSONWithArrayAsRootIsError {
    XCTAssertNil([builder dataFromJSON:@"[]" error:NULL],
                 @"Should not attempt to parse non-array JSON");
}

- (void)testJSONWithNoInterestPointsKeyIsError {
    XCTAssertNil([builder dataFromJSON:@"{}" error:NULL],
                 @"Should not attempt to parse JSON with missing `interest_points` key");
}

- (void)testIllFormedErrorSetWhenJSONHasArrayAsRoot {
    NSError *error = nil;
    [builder dataFromJSON:@"[]" error:&error];
    
    XCTAssertEqual([error code],
                   SkylinePointBuilderIllFormedDataError,
                   @"Should set IllFormed error if root is object");
}

#pragma mark - Valid JSON

- (void)testJSONWithOneObjectPlaceReturnsOneSkylinePointObject {
    NSArray *skylinePoints = [builder dataFromJSON:fullJSON error:NULL];
    XCTAssertEqual([skylinePoints count],
                   (NSUInteger)1,
                   @"The builder should create a SkylinePoint");
}

- (void)testJSONIsParsedAsExpected {
    NSArray *skylinePoints = [builder dataFromJSON:fullJSON error:NULL];
    SkylinePoint *skylinePoint = skylinePoints[0];
    
    XCTAssertEqualWithAccuracy(skylinePoint.coordinate.x, 1, 0.1);
    XCTAssertEqualWithAccuracy(skylinePoint.coordinate.y, 1, 0.1);
    
    XCTAssertEqualObjects(skylinePoint.interestPoint.name, @"U.S. Steel Tower");
    XCTAssertEqualObjects(skylinePoint.interestPoint.address, @"600 Grant Street");
    XCTAssertEqualObjects(skylinePoint.interestPoint.description, @"Big ol' building");
    
    XCTAssertEqualObjects(skylinePoint.interestPoint.imageUrl, @"image.png");
}

@end
