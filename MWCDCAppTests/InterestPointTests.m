//
//  InterestPointTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InterestPoint.h"

@interface InterestPointTests : XCTestCase
{
    InterestPoint *interestPoint;
}
@end

@implementation InterestPointTests

- (void)setUp
{
    [super setUp];
    interestPoint = [[InterestPoint alloc] initWithName:@"U.S. Steel Tower"
                                                address:@"600 Grant Street"
                                               description:@"Big ol' building"];
}

- (void)tearDown
{
    interestPoint = nil;
    [super tearDown];
}

- (void)testCanBeInitializedWithArguments
{
    XCTAssertEqualObjects(interestPoint.address, @"600 Grant Street");
    XCTAssertEqualObjects(interestPoint.name, @"U.S. Steel Tower");
    XCTAssertEqualObjects(interestPoint.description, @"Big ol' building");
}

@end
