//
//  PlaceDataFetcher.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDataFetcherDelegate.h"
#import "APICommunicator.h"
#import "PlaceBuilder.h"

@interface PlaceDataStore : NSObject <APICommunicatorDelegate>

@property (nonatomic, weak) id<PlaceDataFetcherDelegate> delegate;
@property (nonatomic, strong) APICommunicator *communicator;
@property (nonatomic, strong) PlaceBuilder *placeBuilder;

+ (PlaceDataStore *)defaultFetcher;

- (void)fetchPlaces;
- (void)fetchingDataFailedWithError:(NSError *)err;
- (void)receivedDataJSON:(NSString *)objectNotation;

@end

extern NSString* const PlaceDataFetcherErrorDomain;

enum {
    PlaceDataFetcherErrorSearchCode
};

