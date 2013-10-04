//
//  PlaceTableViewControllerTests.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PlaceTableViewController.h"
#import "PlaceTableDataSource.h"
#import "PlaceTableDelegate.h"

@interface PlaceTableViewControllerTests : XCTestCase
{
    PlaceTableViewController *vc;
    UITableView *tableView;
    
    id <UITableViewDataSource> dataSource;
    PlaceTableDelegate *delegate;
}
@end

@implementation PlaceTableViewControllerTests

- (void)setUp
{
    [super setUp];
    vc = [[PlaceTableViewController alloc] init];
    tableView = [[UITableView alloc] init];
    vc.tableView = tableView;
    
    dataSource = [[PlaceTableDataSource alloc] init];
    delegate = [[PlaceTableDelegate alloc] init];
    
    vc.dataSource = dataSource;
    vc.delegate = delegate;
}

- (void)tearDown
{
    vc = nil;
    tableView = nil;
    [super tearDown];
}

- (void)testDelegateIsSetAfterViewLoads
{
    [vc viewDidLoad];
    XCTAssertEqual(delegate,
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

- (void)testDataSourceIsConnectedToDelegate
{
    vc.dataSource = dataSource;
    vc.delegate = delegate;
    [vc viewDidLoad];
    XCTAssertEqual(vc.delegate.tableDataSource,
                   dataSource,
                   @"Should give delegate a reference to the dataSource");
}

@end
