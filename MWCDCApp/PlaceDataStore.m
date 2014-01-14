//
//  PlaceDataFetcher.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDataStore.h"

@interface PlaceDataStore ()

- (void)notifyDelegateAboutAPIFetchError:(NSError *)underlyingError;

@end

@implementation PlaceDataStore

+ (PlaceDataStore *)defaultFetcher
{
    PlaceDataStore *fetcher = [[PlaceDataStore alloc] init];
    fetcher.communicator = [[APICommunicator alloc] init];
    fetcher.communicator.delegate = fetcher;
    
    fetcher.placeBuilder = [[PlaceBuilder alloc] init];
    
    return fetcher;
}

- (void)fetchPlaces {
    [self.communicator fetchPlaces];
}

- (void)fetchingDataFailedWithError:(NSError*)err {
    [self notifyDelegateAboutAPIFetchError:err];
}

- (void)receivedDataJSON:(NSString *)objectNotation {
    NSError *err = nil;
    NSArray *places = [self.placeBuilder placesFromJSON: objectNotation
                                             error: &err];
    if (!places) {
        [self notifyDelegateAboutAPIFetchError:err];
    }
    else {
        [self.delegate didReceivePlaces:places];
    }
}

/** private **/
- (void)notifyDelegateAboutAPIFetchError:(NSError *)underlyingError {
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