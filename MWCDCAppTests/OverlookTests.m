//
//  OverlookTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "Overlook.h"

@interface OverlookTests : XCTestCase
{
    Overlook *overlook;
}
@end

@implementation OverlookTests

- (void)setUp
{
    [super setUp];
    overlook = [[Overlook alloc] initWithId:1
                                       name:@"Duquesne Incline"
                                 coordinate:CLLocationCoordinate2DMake(40.438406, -80.019500)];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testOverlookCAnBeInitializedWithArguments
{
    XCTAssertEqual(overlook._id, (NSInteger)1, @"should store id");
    XCTAssertEqualObjects(overlook.name, @"Duquesne Incline", @"should store name");
    XCTAssertEqualWithAccuracy(overlook.coordinate.latitude, 40.438406, 1e-6, "@should store latitude");
    XCTAssertEqualWithAccuracy(overlook.coordinate.longitude, -80.019500, 1e-6, "@should store longitude");
}

#pragma mark - MKAnnotation protocol conformance tests

- (void)testOverlookRespondsToCoordinate
{
    XCTAssertNotEqual(overlook.coordinate.latitude, 0);
    XCTAssertNotEqual(overlook.coordinate.longitude, 0);
}

- (void)testOverlookRespondsToTitleWithName
{
    XCTAssertEqualObjects([overlook title], @"Duquesne Incline");
}

@end
