//
//  PlaceDataFetcher.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDataFetcher.h"

@interface PlaceDataFetcher ()

- (void)notifyDelegateAboutPlaceSearchError:(NSError *)underlyingError;

@end

@implementation PlaceDataFetcher

+ (PlaceDataFetcher *)defaultFetcher
{
    PlaceDataFetcher *fetcher = [[PlaceDataFetcher alloc] init];
    fetcher.communicator = [[APICommunicator alloc] init];
    fetcher.communicator.delegate = fetcher;
    
    fetcher.placeBuilder = [[PlaceBuilder alloc] init];
    
    return fetcher;
}

- (void)fetchPlaces {
    [self.communicator fetchPlaces];
}

- (void)searchingForPlacesFailedWithError:(NSError*)err {
    [self notifyDelegateAboutPlaceSearchError:err];
}

- (void)receivedPlacesJSON:(NSString *)objectNotation {
    NSError *err = nil;
    NSArray *places = [self.placeBuilder placesFromJSON: objectNotation
                                             error: &err];
    if (!places) {
        [self notifyDelegateAboutPlaceSearchError:err];
    }
    else {
        [self.delegate didReceivePlaces:places];
    }
}

/** private **/
- (void)notifyDelegateAboutPlaceSearchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = @{NSUnderlyingErrorKey: underlyingError};
    }
    NSError *reportableErr = [NSError
                              errorWithDomain:PlaceDataFetcherErrorDomain
                              code:PlaceDataFetcherErrorSearchCode
                              userInfo:errorInfo];
    [self.delegate fetchingPlacesFailedWithError:reportableErr];
}


@end

NSString* const PlaceDataFetcherErrorDomain = @"PlaceDataFetcher";