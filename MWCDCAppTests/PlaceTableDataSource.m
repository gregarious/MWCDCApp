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

@synthesize places, lastError;

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    
    if (places) {
        return [places count];
    }
    else {
        return 1;
    }

}

NSString * const placeCellReuseIdenitifier = @"Place";
NSString * const errorCellReuseIdenitifier = @"PlaceError";
NSString * const loadingCellReuseIdenitifier = @"PlaceLoading";

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSParameterAssert([indexPath section] == 0);

    UITableViewCell *cell;
    if (places) {
        NSParameterAssert([indexPath row] < [places count]);
        cell = [tableView dequeueReusableCellWithIdentifier:placeCellReuseIdenitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellReuseIdenitifier];
        }
        
        Place *place = [places objectAtIndex:[indexPath row]];
        cell.textLabel.text = place.name;
    }
    else {
        NSParameterAssert([indexPath row] == 0);
        if (lastError) {
            cell = [tableView dequeueReusableCellWithIdentifier:errorCellReuseIdenitifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:errorCellReuseIdenitifier];
            }
            cell.textLabel.text = [lastError localizedDescription];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:loadingCellReuseIdenitifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCellReuseIdenitifier];
            }
            cell.textLabel.text = @"Loading places...";
        }
    }
    
    return cell;
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