//
//  PlaceTableViewDataSource.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableDataSource.h"
#import "Place.h"

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

- (Place *)placeForIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath row] < [places count]);
    NSParameterAssert([indexPath section] == 0);

    return [places objectAtIndex:[indexPath row]];
}

@end
