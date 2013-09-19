//
//  MockPlaceAPICommunicator.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "MockPlaceAPICommunicator.h"

@implementation MockPlaceAPICommunicator
{
    BOOL _wasAskedToFetchPlaces;
}

- (BOOL)wasAskedToFetchPlaces {
    return _wasAskedToFetchPlaces;
}

- (void)fetchPlaces {
    _wasAskedToFetchPlaces = YES;
}

@end
