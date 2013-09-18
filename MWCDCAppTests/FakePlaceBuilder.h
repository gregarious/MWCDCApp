//
//  FakePlaceBuilder.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceBuilder.h"

@interface FakePlaceBuilder : PlaceBuilder

@property (nonatomic, copy) NSString *JSON;
@property (nonatomic, copy) NSArray *arrayToReturn;
@property (nonatomic, copy) NSError *errorToSet;

@end
