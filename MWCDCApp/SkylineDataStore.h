//
//  SkylineDataStore.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkylineDataStoreDelegate.h"
#import "APICommunicatorDelegate.h"

@class SkylinePointBuilder;
@class APICommunicator;

@interface SkylineDataStore : NSObject <APICommunicatorDelegate>
{
    NSInteger currentlyFetchingOverlookID;
}
@property (nonatomic, weak) id<SkylineDataStoreDelegate> delegate;
@property (nonatomic, strong) APICommunicator *communicator;
@property (nonatomic, strong) SkylinePointBuilder *objectBuilder;

+ (SkylineDataStore *)defaultFetcher;

- (void)fetchSkylinePoints:(NSInteger)overlookID;

- (void)fetchingDataFailedWithError:(NSError*)err;
- (void)receivedDataJSON:(NSString *)objectNotation;

@end

extern NSString* const SkylineDataFetcherErrorDomain;
enum {
    SkylineDataFetcherErrorSearchCode
};

