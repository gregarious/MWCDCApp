//
//  PlaceTableViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PlaceTableViewController.h"
#import "PlaceDetailViewController.h"
#import "PlaceTableDataSource.h"
#import "Place.h"

#import <objc/runtime.h>

static const char *notificationKey = "PlaceTableViewControllerTestsAssociatedNotificationKey";
static const char *viewDidAppearKey = "PlaceTableViewControllerTestsViewDidAppearKey";
static const char *viewWillDisappearKey = "PlaceTableViewControllerTestsViewWillDisappearKey";

// category to allow directly observing place selection notifications
@implementation PlaceTableViewController (TestNotificationDelivery)

- (void)placeTableViewControllerTests_userDidSelectPlaceNotification: (NSNotification *)note {
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

@end

// category to spy on viewDidAppear/viewWillDisappear
@implementation UIViewController (TestSuperclassesCalled)

- (void)placeTableViewControllerTests_viewDidAppear: (BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, viewDidAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)placeTableViewControllerTests_viewWillDisappear: (BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, viewWillDisappearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

@end

@interface PlaceTableViewControllerTests : XCTestCase
{
    PlaceTableViewController *vc;
    UITableView *tableView;
    UINavigationController *navController;
    
    NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;
    
    SEL realViewDidAppear, testViewDidAppear;
    SEL realViewWillDisappear, testViewWillDisappear;
    SEL realUserDidSelectPlaceNotification, testUserDidSelectPlaceNotification;
}
@end

@implementation PlaceTableViewControllerTests

+ (void)swapInstanceMethodsForClass:(Class)cls
                           selector:(SEL)sel1
                        andSelector:(SEL)sel2
{
    Method method1 = class_getInstanceMethod(cls, sel1);
    Method method2 = class_getInstanceMethod(cls, sel2);
    method_exchangeImplementations(method1, method2);
}

- (void)setUp
{
    [super setUp];
    vc = [[PlaceTableViewController alloc] init];
    navController = [[UINavigationController alloc] initWithRootViewController:vc];

    tableView = [[UITableView alloc] init];
    vc.tableView = tableView;
    
    dataSource = [[PlaceTableDataSource alloc] init];
    vc.dataSource = dataSource;
    
    objc_removeAssociatedObjects(vc);
    
    // add spies to ensure view conforms with super requirements
    [self spyOnSuperCalls];
}

- (void)tearDown
{
    objc_removeAssociatedObjects(vc);
    tableView = nil;
    vc = nil;
    navController = nil;
    
    [self removeAllSpies];
    
    [super tearDown];
}

- (void)testDelegateIsSetAfterViewLoads
{
    [vc viewDidLoad];
    XCTAssertEqual(dataSource,
                   [[vc tableView] delegate],
                   @"Should set delegate when view loads");
}

- (void)testDataSourceIsSetAfterViewLoads
{
    [vc viewDidLoad];
    XCTAssertEqual(dataSource,
                   [[vc tableView] dataSource],
                   @"Should set dataSource when view loads");
    
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications
{
    [self spyOnPlaceSelectionNotification];
    
    [self postNotification];
    XCTAssertNil(objc_getAssociatedObject(vc, notificationKey),
                 @"Should not respond to place select notifications by default");
}

- (void)testViewControllerDoesReceiveNotificationsAfterViewWillAppear
{
    [self spyOnPlaceSelectionNotification];
    
    [vc viewDidAppear: NO];
    [self postNotification];
    XCTAssertNotNil(objc_getAssociatedObject(vc, notificationKey),
                 @"Should respond to place select notifications if view has appeared");
}

- (void)testSelectedNotificationPassesPlaceAsObject
{
    
}

- (void)testViewControllerCallsSuperViewDidAppear
{
    [vc viewDidAppear:NO];
    XCTAssertNotNil(objc_getAssociatedObject(vc, viewDidAppearKey), @"-viewDidAppear: should call through to superclass impl");
}

- (void)testViewControllerCallsSuperViewWillDisappear
{
    [vc viewWillDisappear:NO];
    XCTAssertNotNil(objc_getAssociatedObject(vc, viewWillDisappearKey), @"-viewWillDisappear: should call through to superclass impl");
}

- (void)testSelectingPlacePushesNewViewController
{
    [vc userDidSelectPlaceNotification:nil];
    UIViewController *currentTopVC = navController.topViewController;
    XCTAssertNotEqualObjects(currentTopVC, vc, @"should push new view controller after user selcts place");
}

- (void)testPushedDetailControllerIsAssignedPlace
{
    Place *selectedPlace = [[Place alloc] init];
    NSNotification *note = [NSNotification notificationWithName:PlaceTableDidReceivePlaceNotification object:selectedPlace];
    [vc userDidSelectPlaceNotification:note];
    
    PlaceDetailViewController *detailVC = (PlaceDetailViewController *)navController.topViewController;
    XCTAssertEqualObjects(detailVC.place, selectedPlace, @"should assign new detail controller the selected place");
}

/* helpers */
- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaceTableDidReceivePlaceNotification object:nil];
}

- (void)spyOnSuperCalls
{
    realViewDidAppear = @selector(viewDidAppear:);
    testViewDidAppear = @selector(placeTableViewControllerTests_viewDidAppear:);
    realViewWillDisappear = @selector(viewWillDisappear:);
    testViewWillDisappear = @selector(placeTableViewControllerTests_viewWillDisappear:);

    [PlaceTableViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    [PlaceTableViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
}

- (void)spyOnPlaceSelectionNotification
{
    realUserDidSelectPlaceNotification = @selector(userDidSelectPlaceNotification:);
    testUserDidSelectPlaceNotification = @selector(placeTableViewControllerTests_userDidSelectPlaceNotification:);

    [PlaceTableViewControllerTests swapInstanceMethodsForClass:[PlaceTableViewController class] selector:realUserDidSelectPlaceNotification andSelector:testUserDidSelectPlaceNotification];
}

- (void)removeAllSpies
{
    // don't un-swizzle methods that haven't been swizzled in the first place
    if (realViewDidAppear) {
        [PlaceTableViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    }
    if (realViewWillDisappear) {
        [PlaceTableViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    }
    if (realUserDidSelectPlaceNotification) {
        [PlaceTableViewControllerTests swapInstanceMethodsForClass:[PlaceTableViewController class] selector:testUserDidSelectPlaceNotification andSelector:realUserDidSelectPlaceNotification];
    }
}
@end