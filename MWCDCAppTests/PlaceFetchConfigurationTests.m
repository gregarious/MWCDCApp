//
//  PlaceFetchConfigurationTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/11/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlaceFetchConfiguration.h"
#import "PlaceDataManager.h"

@interface PlaceFetchConfigurationTests : XCTestCase
{
    PlaceFetchConfiguration *configuration;
}
@end

@implementation PlaceFetchConfigurationTests

- (void)setUp
{
    [super setUp];
    configuration = [[PlaceFetchConfiguration alloc] init];
}

- (void)tearDown
{
    configuration = nil;
    [super tearDown];
}

- (void)testConfigurationProvidesAllComponents
{
    PlaceDataManager *manager = [configuration dataManager];
    XCTAssertNotNil(manager.communicator);
    XCTAssertNotNil(manager.placeBuilder);
}

@end
