//
//  PlaceTableDelegateTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PlaceTableDataSource.h"
#import "PlaceTableDelegate.h"
#import "Place.h"

@interface PlaceTableDelegateTests : XCTestCase
{
    NSNotification *receivedNotification;
    PlaceTableDataSource *dataSource;
    PlaceTableDelegate *delegate;
    NSArray *placesList;
    Place *samplePlace;
}
@end

@implementation PlaceTableDelegateTests

- (void)setUp
{
    [super setUp];
    delegate = [[PlaceTableDelegate alloc] init];
    dataSource = [[PlaceTableDataSource alloc] init];
    samplePlace = [[Place alloc] initWithName:@"Shiloh Grill"
                                streetAddress:@"123 Shiloh St."
                                   coordinate:CLLocationCoordinate2DMake(40, -80)];
    placesList = @[samplePlace];
    [dataSource setPlaces: placesList];

    delegate.tableDataSource = dataSource;
    
    // add simple observer to check that notification is posted
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(didReceiveNotification:)
            name:PlaceTableDidReceivePlaceNotification
          object:nil];
}

- (void)tearDown
{
    dataSource = nil;
    delegate = nil;
    samplePlace = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super tearDown];
}

// fake callback for notification center
- (void)didReceiveNotification: (NSNotification *)note {
    receivedNotification = note;
}

- (void)testDelegatePostsNotificationOnPlaceSelection {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [delegate tableView:nil didSelectRowAtIndexPath:path];
    XCTAssertEqualObjects([receivedNotification name],
                          PlaceTableDidReceivePlaceNotification,
                          @"Should send notification on place selection");
    XCTAssertEqualObjects([receivedNotification object],
                          samplePlace,
                          @"Should send selected place in notification");
}

@end
