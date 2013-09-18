//
//  FakePlaceBuilder.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "FakePlaceBuilder.h"

@implementation FakePlaceBuilder

@synthesize JSON, arrayToReturn, errorToSet;

- (NSArray *)placesFromJSON: (NSString *)objectNotation
                      error: (NSError **)error {
    self.JSON = objectNotation;
    *error = errorToSet;
    return arrayToReturn;
}

@end
