//
//  MarkerView.m
//  SkylinePOC
//
//  Created by Greg Nicholas on 11/22/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "MarkerView.h"
#import "SkylineView.h"

@implementation MarkerView

- (id)initWithPoint:(SkylinePoint *)skylinePoint
{
    self = [super initWithImage:[UIImage imageNamed:@"circle_marker"]];
    if (self) {
        _skylinePoint = skylinePoint;
    }
    return self;
}

@end
