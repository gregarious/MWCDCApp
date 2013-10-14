//
//  SkylinePoint.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//
//  Wrapper to join an InterestPoint and an x,y coordinate on an
//  overlook image

#import <Foundation/Foundation.h>
#import "InterestPoint.h"

@interface SkylinePoint : NSObject

@property (nonatomic, strong, readonly) InterestPoint *interestPoint;
@property (nonatomic, assign, readonly) CGPoint imageCoordinates;

- (id)initWithInterestPoint:(InterestPoint *)interestPoint
           imageCoordinates:(CGPoint)imageCoordinates;

@end
