//
//  SCEPlace.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithName:(NSString *)newName
     streetAddress:(NSString *)newAddress
        coordinate:(CLLocationCoordinate2D)newCoord
{
    if ((self = [super init])) {
        _name = [newName copy];
        _coordinate = newCoord;  // struct copies when assigned
        _streetAddress = [newAddress copy];
    }
    return self;
}

@end
