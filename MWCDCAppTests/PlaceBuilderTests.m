//
//  QuestionBuilderTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlaceBuilder.h"
#import "Place.h"

@interface PlaceBuilderTests : XCTestCase {
@private
    PlaceBuilder *builder;
    NSString *fullJSON;
    NSString *basicJSON;
    NSString *nameOmittedJSON;
    NSString *addressOmittedJSON;
    NSString *nullCoordinateJSON;
}
@end

@implementation PlaceBuilderTests

- (void)setUp
{
    [super setUp];
    builder = [[PlaceBuilder alloc] init];
    fullJSON = @"[{"
        @"\"id\": 54,"
        @"\"name\": \"Shiloh Grill\","
        @"\"street_address\": \"123 Shiloh Street\","
        @"\"latitude\": 40.431683,"
        @"\"longitude\": -80.006637,"
        @"\"description\": \"This is a fun restaurant and it has food!\","
        @"\"hours\": \"\","
        @"\"fb_id\": \"\","
        @"\"twitter_handle\": \"ShilohGrill\","
        @"\"phone\": \"(412) 431-4000\","
        @"\"website\": \"http://shilohgrill.com/\","
        @"\"image_url\": \"http://shilohgrill.com/pic.png\","
        @"\"category_id\": 1,"
        @"\"category_label\": \"restaurant\""
    @"}]";
    
    basicJSON = @"[{\"name\": \"\", \"address\": \"\"}]";

    nameOmittedJSON = @"[{\"street_address\": \"\", \"latitude\": 0, \"longitude\": 0}]";
    addressOmittedJSON = @"[{\"name\": \"\", \"latitude\": 0, \"longitude\": 0}]";
    nullCoordinateJSON = @"[{\"name\": \"\", \"street_address\": \"\", \"latitude\": null, \"longitude\": null}]";
}

- (void)tearDown
{
    builder = nil;
    [super tearDown];
}

/** Parameter assertions **/
- (void)testThatNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([builder placesFromJSON:nil error:NULL],
                    @"Lack of data should have been handled elsewhere.");
}

/** Invalid JSON tests **/

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([builder placesFromJSON:@"Invalid JSON"
                                   error:NULL],
                 @"Unparsable JSON should yield nil.");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [builder placesFromJSON:@"Invalid JSON"
                      error:&error];
    XCTAssertNotNil(error, @"Unparsable JSON should set an error.");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([builder placesFromJSON:@"Invalid JSON"
                                       error:NULL],
                     @"A NULL error parameter should be allowed.");
}

/** Invalid but well-formed JSON tests **/

- (void)testJSONWithObjectAsRootIsError {
    XCTAssertNil([builder placesFromJSON:@"{}"
                                   error:NULL],
                 @"Should not attempt to parse non-array JSON");
}

- (void)testIllFormedErrorSetWhenJSONHasObjectAsRoot {
    NSError *error = nil;
    [builder placesFromJSON:@"{}"
                      error:&error];
    
    XCTAssertEqual([error code],
                 PlaceBuilderIllFormedDataError,
                 @"Should set IllFormed error if root is object");
}

/* Note that the following conditions don't get any error set: a nil
   value is silently set for the respective incomplete place item
   and execution continues */
 
- (void)testJSONWithOmittedNameYieldsNull {
    NSArray* places = [builder placesFromJSON:nameOmittedJSON error:NULL];
    XCTAssertEqualObjects(places[0], [NSNull null],
                 @"Should not attempt to parse JSON without name");
}

- (void)testJSONWithOmittedAddressYieldsNull {
    NSArray* places = [builder placesFromJSON:addressOmittedJSON error:NULL];
    XCTAssertEqualObjects(places[0], [NSNull null],
                 @"Should not attempt to parse JSON without address");
}

- (void)testJSONWithNullCoordinatesYieldsPlaceWithZeroCoords {
    NSArray* places = [builder placesFromJSON:nullCoordinateJSON error:NULL];
    Place *place = places[0];
    
    XCTAssertNotNil(place, @"Should successfully parse");
    XCTAssertEqualWithAccuracy(place.coordinate.latitude, 0, 1e-6, @"Should set coordinates to 0 if JSON has null");
    XCTAssertEqualWithAccuracy(place.coordinate.latitude, 0, 1e-6, @"Should set coordinates to 0 if JSON has null");
}


/** Valid JSON parsing tests **/

- (void)testJSONWithOnePlaceReturnsOnePlaceObject {
    NSArray *places = [builder placesFromJSON:fullJSON error:NULL];
    XCTAssertEqual([places count],
                   (NSUInteger)1,
                   @"The builder should create a place");
}

- (void)testJSONIsParsedAsExpected {
    NSArray *places = [builder placesFromJSON:fullJSON error:NULL];
    Place *place = places[0];
    
    XCTAssertEqualObjects(place.name, @"Shiloh Grill", @"Should parse name");
    XCTAssertEqualObjects(place.streetAddress, @"123 Shiloh Street", @"Should set address");
    XCTAssertEqualWithAccuracy(place.coordinate.latitude, 40.431683, 1e-6, @"Should set latitude");
    XCTAssertEqualWithAccuracy(place.coordinate.longitude, -80.006637, 1e-6, @"Should set longitude");
    
    XCTAssertEqualObjects(place.description, @"This is a fun restaurant and it has food!", @"Should set description");
    XCTAssertEqualObjects(place.hours, @"", @"Should set hours");
    XCTAssertEqualObjects(place.fbId, @"", @"Should set fbId");
    XCTAssertEqualObjects(place.twitterHandle, @"ShilohGrill", @"Should set twitterId");
    XCTAssertEqualObjects(place.phone, @"(412) 431-4000", @"Should set phone");
    XCTAssertEqualObjects(place.website, @"http://shilohgrill.com/", @"Should set website");
    XCTAssertEqual(place.categoryId, (NSInteger)1, @"Should set category id as number");
    XCTAssertEqualObjects(place.categoryLabel, @"restaurant", @"Should set category as a string");
    
    XCTAssertEqualObjects(place.imageURLString, @"http://shilohgrill.com/pic.png", @"Should set image url");
    
    
}

- (void)testJSONWithOnlyRequiredPropertiesSucceeds
{
    NSArray *places = [builder placesFromJSON:basicJSON error:NULL];
    Place *place = places[0];
    XCTAssertNotNil(place, @"JSON should be acceptable with only name, address, latitutde, and longitude");
}

@end
