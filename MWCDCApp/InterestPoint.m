//
//  InterestPoint.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "InterestPoint.h"

@implementation InterestPoint

- (id)initWithName:(NSString *)name
           address:(NSString *)address
       description:(NSString *)description
{
    self = [super init];
    if (self) {
        _name = name;
        _address = address;
        _description = description;
    }
    return self;
}

@end
