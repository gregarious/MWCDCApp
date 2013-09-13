//
//  SCEPlaceTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "SCEPlace.h"

@interface SCEPlaceTests : XCTestCase {
    SCEPlace *place;
}
@end

@implementation SCEPlaceTests

- (void)setUp
{
    [super setUp];
    place = [[SCEPlace alloc] initWithName:@"Shiloh Grill"
                             streetAddress:@"123 Shiloh Street"
                                coordinate:CLLocationCoordinate2DMake(40.431683,-80.006637)];
}

- (void)tearDown
{
    place = nil;
    [super tearDown];
}

- (void)testThatPlaceInitializes
{
    XCTAssertNotNil(place, @"should be able to create SCEPlace instance");
}

- (void)testThatPlaceCanBeNamed
{
    XCTAssertEqualObjects(place.name, @"Shiloh Grill",
                          @"the Place should have the name given");
    
}

- (void)testThatPlaceCanHaveAddress
{
    XCTAssertEqualObjects(place.streetAddress, @"123 Shiloh Street", @"the Place should store the given address");
}

- (void)testThatPlaceCanHaveCoordinate
{
    XCTAssertEqualWithAccuracy(place.coordinate.latitude, 40.431683, 1e-6, @"the Place should store the given latitude");
    XCTAssertEqualWithAccuracy(place.coordinate.longitude, -80.006637, 1e-6, @"the Place should store the given longitude");
}

@end
