//
//  PlaceTableViewDataSource.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableDataSource.h"
#import "Place.h"
#import "PlaceTableViewCell.h"

@interface PlaceTableDataSource ()
- (Place *)placeForIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PlaceTableDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    
    if (self.places) {
        return self.places.count;
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

    if (self.places) {
        NSParameterAssert([indexPath row] < [self.places count]);
        PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellReuseIdenitifier];
        if (!cell) {
            cell = [[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellReuseIdenitifier];
        }
        
        Place *place = [self.places objectAtIndex:[indexPath row]];

        cell.nameLabel.text = place.name;
        
        // connect a weak ref directly to the object
        cell.place = place;
        
        return cell;
    }
    else {
        NSParameterAssert([indexPath row] == 0);
        UITableViewCell *cell;
        if (self.lastError) {
            cell = [tableView dequeueReusableCellWithIdentifier:errorCellReuseIdenitifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:errorCellReuseIdenitifier];
            }
            cell.textLabel.text = [self.lastError localizedDescription];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:loadingCellReuseIdenitifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCellReuseIdenitifier];
            }
            cell.textLabel.text = @"Loading places...";
        }
        return cell;
    }
    
}


/* private */

- (Place *)placeForIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath row] < [self.places count]);
    NSParameterAssert([indexPath section] == 0);
    
    return [self.places objectAtIndex:[indexPath row]];
}



@end

NSString* const PlaceTableDidReceivePlaceNotification = @"PlaceTableDidReceivePlaceNotification";