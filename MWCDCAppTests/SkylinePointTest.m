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
    interestPoint = [[InterestPoint alloc]
                     initWithName:@"Building"
                     address:@"Somewhere"
                     description:@"Description"];
    
    skylinePoint = [[SkylinePoint alloc] initWithInterestPoint:interestPoint
                                                    coordinate:CGPointMake(1.0, 1.0)];
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
    XCTAssertEqualWithAccuracy(skylinePoint.coordinate.x, 1.0, 0.1);
    XCTAssertEqualWithAccuracy(skylinePoint.coordinate.y, 1.0, 0.1);
}

- (void)testTitleRespondsWithInterestPointName
{
    XCTAssertEqualObjects(skylinePoint.title, @"Building", @"should respond with the title of the interest point");
}

@end
