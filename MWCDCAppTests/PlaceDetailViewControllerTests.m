//
//  PlaceDetailViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlaceDetailViewController.h"
#import "Place.h"

@interface PlaceDetailViewControllerTests : XCTestCase
{
    Place *samplePlace;
    PlaceDetailViewController *vc;
}
@end

@implementation PlaceDetailViewControllerTests

- (void)setUp
{
    [super setUp];
    samplePlace = [[Place alloc] initWithName:@"Shiloh Grill"
                                streetAddress:@"123 Shiloh St."
                                   coordinate:CLLocationCoordinate2DMake(40, -80)];
    vc = [[PlaceDetailViewController alloc] init];
    [vc setPlace:samplePlace];

    // Note: artificially loading the view to allow for tests that require
    // view configuration to work. Better design would be to view setup to
    // actually happen in a UIView, but now is not the time to rail against
    // the machine (see http://bit.ly/1cxjrUp).
    
    [vc loadView];
    [vc viewDidLoad];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testThatNameIsDisplayedAfterViewLoads
{
    XCTAssertEqualObjects(vc.nameLabel.text, @"Shiloh Grill", @"should display the place name");
}

@end
