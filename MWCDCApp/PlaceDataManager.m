//
//  PlaceDataManager.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDataManager.h"

@interface PlaceDataManager ()

- (void)notifyDelegateAboutPlaceSearchError:(NSError *)underlyingError;

@end

@implementation PlaceDataManager

@synthesize delegate, communicator, placeBuilder;

- (void)fetchPlaces {
    [communicator fetchPlaces];
}

- (void)searchingForPlacesFailedWithError:(NSError*)err {
    [self notifyDelegateAboutPlaceSearchError:err];
}

- (void)receivedPlacesJSON:(NSString *)objectNotation {
    NSError *err = nil;
    NSArray *places = [placeBuilder placesFromJSON: objectNotation
                                             error: &err];
    if (!places) {
        [self notifyDelegateAboutPlaceSearchError:err];
    }
    else {
        [delegate didReceivePlaces:places];
    }
}

/** private **/
- (void)notifyDelegateAboutPlaceSearchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = @{NSUnderlyingErrorKey: underlyingError};
    }
    NSError *reportableErr = [NSError
                              errorWithDomain:PlaceDataManagerErrorDomain
                              code:PlaceDataManagerErrorSearchCode
                              userInfo:errorInfo];
    [delegate fetchingPlacesFailedWithError:reportableErr];
}


@end

NSString* const PlaceDataManagerErrorDomain = @"PlaceDataManager";