//
//  OverlookListViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>
#import "OverlookListViewController.h"

@implementation OverlookListViewController (Observable)

- (NSArray *)getOverlooks {
    return overlooks;
}

@end

@interface OverlookListViewControllerTests : XCTestCase
{
    OverlookListViewController *vc;
}
@end

@implementation OverlookListViewControllerTests

/*
 * Untested behaviors:
 *
 * - in viewDidLoad, map region, annotations
 * - map view delegate is self (set in storyboard)
 * - mapView:viewForAnnotation: returns annotation with callout button
 * - mapView:annotationView:calloutAccessoryControlTapped: initiates a segue to the SkylineViewController
 * - prepareForSegue:sender: sets the overlook for the skyline view controller
 */

- (void)setUp
{
    [super setUp];
    vc = [[OverlookListViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)tearDown
{
    vc = nil;
    [super tearDown];
}

- (void)testOverlooksSetAfterViewLoads
{
    [vc viewDidLoad];
    XCTAssertNotNil([vc getOverlooks], @"should have overlooks set after view loads");
}

@end
