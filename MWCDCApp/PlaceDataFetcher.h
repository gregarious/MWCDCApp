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

@interface PlaceDataFetcher : NSObject <APICommunicatorDelegate>

@property (nonatomic, weak) id<PlaceDataFetcherDelegate> delegate;
@property (nonatomic, strong) APICommunicator *communicator;
@property (nonatomic, strong) PlaceBuilder *placeBuilder;

+ (PlaceDataFetcher *)defaultFetcher;

- (void)fetchPlaces;
- (void)searchingForPlacesFailedWithError:(NSError *)err;
- (void)receivedPlacesJSON:(NSString *)objectNotation;

@end

extern NSString* const PlaceDataFetcherErrorDomain;

enum {
    PlaceDataFetcherErrorSearchCode
};
