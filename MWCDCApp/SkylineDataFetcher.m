//
//  SkylineDataFetcher.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylineDataFetcher.h"
#import "APICommunicator.h"
#import "SkylinePointBuilder.h"

@interface SkylineDataFetcher ()
- (void)notifyDelegateAboutAPIFetchError:(NSError *)underlyingError;
@end

@implementation SkylineDataFetcher

+ (SkylineDataFetcher *)defaultFetcher
{
    SkylineDataFetcher *fetcher = [[SkylineDataFetcher alloc] init];
    fetcher.communicator = [[APICommunicator alloc] init];
    fetcher.communicator.delegate = fetcher;
    
    fetcher.objectBuilder = [[SkylinePointBuilder alloc] init];
    
    return fetcher;
}

- (void)fetchSkylinePoints:(NSInteger)overlookID {
    currentlyFetchingOverlookID = overlookID;
    [self.communicator fetchInterestPoints:overlookID];
}

- (void)fetchingDataFailedWithError:(NSError*)err {
    [self notifyDelegateAboutAPIFetchError:err];
}

- (void)receivedDataJSON:(NSString *)objectNotation {
    NSError *err = nil;
    NSArray *skylinePoints = [self.objectBuilder dataFromJSON:objectNotation
                                                        error:&err];
    if (!skylinePoints) {
        [self notifyDelegateAboutAPIFetchError:err];
    }
    else {
        [self.delegate didReceiveSkylinePoints:skylinePoints forOverlook:currentlyFetchingOverlookID];
    }
    currentlyFetchingOverlookID = 0;
}

/** private **/
- (void)notifyDelegateAboutAPIFetchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = @{NSUnderlyingErrorKey: underlyingError};
    }
    NSError *reportableErr = [NSError
                              errorWithDomain:SkylineDataFetcherErrorDomain
                              code:SkylineDataFetcherErrorSearchCode
                              userInfo:errorInfo];
    [self.delegate fetchingSkylinePointsFailedWithError:reportableErr];
}

@end

NSString* const SkylineDataFetcherErrorDomain = @"SkylineDataFetcherErrorDomain";