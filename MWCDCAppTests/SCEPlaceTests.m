//
//  SCEPlaceTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SCEPlace.h"

@interface SCEPlaceTests : XCTestCase

@end

@implementation SCEPlaceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testThatSCEPlaceExists
{
    SCEPlace *place = [[SCEPlace alloc] init];
    XCTAssertNotNil(place, @"should be able to create SCEPlace instance");
}

@end
