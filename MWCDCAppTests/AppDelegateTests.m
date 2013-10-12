//
//  AppDelegateTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/11/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PlaceTableViewController.h"

@interface AppDelegateTests : XCTestCase
{
    AppDelegate *appDelegate;
    UITabBarController *rootVC;
}
@end

@implementation AppDelegateTests

- (void)setUp
{
    [super setUp];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    rootVC = (UITabBarController *)[[appDelegate window] rootViewController];
}

- (void)tearDown
{
    rootVC = nil;
    appDelegate = nil;
    [super tearDown];
}

#pragma mark - View controller initializtion tests

- (void)testRootViewControllerIsTabVC
{
    XCTAssertTrue([rootVC isKindOfClass:[UITabBarController class]],
                  @"should have tab bar ctrl as root");
}

- (void)testRootMenuHas4Tabs
{
    XCTAssertEqual([[rootVC viewControllers] count],
                   (NSUInteger)4,
                   @"tab controller should have 4 view controllers");
}

- (void)testTab1IsNotNil
{
    UIViewController *vc = [rootVC viewControllers][0];
    // sanity check: no requirements for this other than it existing
    XCTAssertNotNil(vc, @"tab 1 should be a view controller");
}

- (void)testTab2IsANavController
{
    UINavigationController *placeNavController = (UINavigationController *)([rootVC viewControllers][1]);
    XCTAssertTrue([placeNavController isKindOfClass:[UINavigationController class]],
                   @"tab 2 should be a navigation controller");
}

- (void)testTab3IsANavController
{
    UINavigationController *overlookNavController = (UINavigationController *)([rootVC viewControllers][2]);
    XCTAssertTrue([overlookNavController isKindOfClass:[UINavigationController class]],
                  @"tab 3 should be a navigation controller");
}


- (void)testTab4IsNotNil
{
    UIViewController *vc = [rootVC viewControllers][3];
    // sanity check: no requirements for this other than it existing
    XCTAssertNotNil(vc, @"tab 1 should be a view controller");
}

#pragma mark - Places tab initialization tests

- (void)testPlacesNavHasPlacesTableVCAtTop
{
    UINavigationController *placeNavController = (UINavigationController *)([rootVC viewControllers][1]);
    XCTAssertTrue([[placeNavController topViewController] isKindOfClass:[PlaceTableViewController class]],
                  @"places nav controller should be initialized with a places table view");
}

- (void)testPlacesNavRootIsAPlacesTableVC
{
    UINavigationController *placeNavController = (UINavigationController *)([rootVC viewControllers][1]);
    XCTAssertTrue([[placeNavController topViewController] isKindOfClass:[PlaceTableViewController class]],
                  @"places nav controller should be initialized with a places table view");
}

- (void)testPlacesNavHasAnPlaceFetcherSet {
    UINavigationController *placeNavController = (UINavigationController *)([rootVC viewControllers][1]);
    PlaceTableViewController *tableVC = (PlaceTableViewController *)[placeNavController topViewController];
    XCTAssertNotNil([tableVC dataFetcher],
                    @"places VC should be initialized with a fetcher");
}

@end
