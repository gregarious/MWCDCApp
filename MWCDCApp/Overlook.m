//
//  Overlook.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "Overlook.h"

@implementation Overlook

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coord
{
    if (self = [super init]) {
        _name = [name copy];
        _coordinate = coord;
    }
    return self;
}

-(NSString *)title
{
    return self.name;
}

@end
