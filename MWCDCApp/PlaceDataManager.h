//
//  PlaceDataManager.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDataManagerDelegate.h"
#import "APICommunicator.h"
#import "PlaceBuilder.h"

@interface PlaceDataManager : NSObject

@property (nonatomic, weak) id<PlaceDataManagerDelegate> delegate;
@property (nonatomic, strong) APICommunicator *communicator;
@property (nonatomic, strong) PlaceBuilder *placeBuilder;

- (void)fetchPlaces;
- (void)searchingForPlacesFailedWithError:(NSError *)err;
- (void)receivedPlacesJSON:(NSString *)objectNotation;

@end

extern NSString* const PlaceDataManagerErrorDomain;

enum {
    PlaceDataManagerErrorSearchCode
};