//
//  SkylinePointTest.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InterestPoint.h"
#import "SkylinePoint.h"

@interface SkylinePointTest : XCTestCase
{
    InterestPoint *interestPoint;
    SkylinePoint *skylinePoint;
}
@end

@implementation SkylinePointTest

- (void)setUp
{
    [super setUp];
    interestPoint = [[InterestPoint alloc] init];
    skylinePoint = [[SkylinePoint alloc] initWithInterestPoint:interestPoint
                                              imageCoordinates:CGPointMake(1.0, 1.0)];
}

- (void)tearDown
{
    skylinePoint = nil;
    interestPoint = nil;
    [super tearDown];
}

- (void)testCanBeInitializedWithArguments
{
    XCTAssertEqualObjects(skylinePoint.interestPoint, interestPoint);
    XCTAssertEqualWithAccuracy(skylinePoint.imageCoordinates.x, 1.0, 0.1);
    XCTAssertEqualWithAccuracy(skylinePoint.imageCoordinates.y, 1.0, 0.1);
}

@end
