//
//  SCEPlace.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SCEPlace.h"

@implementation SCEPlace

@synthesize name, coordinate, streetAddress;

@synthesize image;

- (id)initWithName:(NSString *)newName
     streetAddress:(NSString *)newAddress
        coordinate:(CLLocationCoordinate2D)newCoord
{
    if ((self = [super init])) {
        name = [newName copy];
        coordinate = newCoord;  // struct copies when assigned
        streetAddress = [newAddress copy];
    }
    return self;
}

@end
