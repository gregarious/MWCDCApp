//
//  MockPlaceDataManager.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "MockPlaceDataManager.h"

@implementation MockPlaceDataManager

@synthesize fetchError, responseJSON;

- (void)searchingForPlacesFailedWithError:(NSError *)err {
    fetchError = err;
}

- (void)receivedPlacesJSON:(NSString *)objectNotation {
    responseJSON = objectNotation;
}

@end
