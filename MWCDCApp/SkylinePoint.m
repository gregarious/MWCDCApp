//
//  SkylinePoint.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylinePoint.h"

@implementation SkylinePoint

- (id)initWithInterestPoint:(InterestPoint *)interestPoint
                 coordinate:(CGPoint)coordinate
{
    self = [super init];
    if (self) {
        _interestPoint = interestPoint;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return self.interestPoint.name;
}

@end
