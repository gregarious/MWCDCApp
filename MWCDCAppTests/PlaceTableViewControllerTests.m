//
//  PlaceTableViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PlaceTableViewController.h"
#import "PlaceTableViewDataSource.h"
#import "PlaceTableViewDelegate.h"

@interface PlaceTableViewControllerTests : XCTestCase
{
    PlaceTableViewController *vc;
    UITableView *tableView;
}
@end

@implementation PlaceTableViewControllerTests

- (void)setUp
{
    [super setUp];
    vc = [[PlaceTableViewController alloc] init];
    tableView = [[UITableView alloc] init];
    vc.tableView = tableView;
}

- (void)tearDown
{
    vc = nil;
    tableView = nil;
    [super tearDown];
}

- (void)testDelegateIsSetAfterViewLoads
{
    id <UITableViewDelegate> delegate = [[PlaceTableViewDelegate alloc] init];
    vc.delegate = delegate;
    [vc viewDidLoad];
    XCTAssertEqual(delegate,
                   [[vc tableView] delegate],
                   @"Should set delegate when view loads");
}

- (void)testDataSourceIsSetAfterViewLoads
{
    id <UITableViewDataSource> dataSource = [[PlaceTableViewDataSource alloc] init];
    vc.dataSource = dataSource;
    [vc viewDidLoad];
    XCTAssertEqual(dataSource,
                   [[vc tableView] dataSource],
                   @"Should set delegate when view loads");
    
}

@end
