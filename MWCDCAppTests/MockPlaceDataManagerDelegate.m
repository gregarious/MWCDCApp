//
//  MockPlaceDataManagerDelegate.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "MockPlaceDataManagerDelegate.h"

@implementation MockPlaceDataManagerDelegate

@synthesize fetchError;
@synthesize receivedPlaces;

- (void)fetchingPlacesFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)didReceivePlaces:(NSArray *)places {
    self.receivedPlaces = places;
}

@end
