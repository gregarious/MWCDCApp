//
//  PlaceTableViewDataSource.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableDataSource.h"
#import "Place.h"

@interface PlaceTableDataSource ()
- (Place *)placeForIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PlaceTableDataSource

@synthesize places;

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return [places count];
}


NSString * const placeCellReuseIdenitifier = @"Place";

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([indexPath row] < [places count]);
    NSParameterAssert([indexPath section] == 0);
    
    Place *place = [places objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellReuseIdenitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellReuseIdenitifier];
    }
    
    cell.textLabel.text = place.name;
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotification *note = [NSNotification
                            notificationWithName:PlaceTableDidReceivePlaceNotification
                            object:[self placeForIndexPath:indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

/* private */

- (Place *)placeForIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath row] < [places count]);
    NSParameterAssert([indexPath section] == 0);
    
    return [places objectAtIndex:[indexPath row]];
}



@end

NSString* const PlaceTableDidReceivePlaceNotification = @"PlaceTableDidReceivePlaceNotification";