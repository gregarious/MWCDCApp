//
//  PlaceTableViewDelegate.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableDelegate.h"
#import "PlaceTableDataSource.h"

@implementation PlaceTableDelegate

@synthesize tableDataSource;

- (void)        tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotification *note = [NSNotification
                            notificationWithName:PlaceTableDidReceivePlaceNotification
                            object:[tableDataSource placeForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

@end

NSString* const PlaceTableDidReceivePlaceNotification = @"PlaceTableDidReceivePlaceNotification";