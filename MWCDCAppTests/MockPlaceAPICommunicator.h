//
//  MockPlaceAPICommunicator.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceAPICommunicator.h"

@interface MockPlaceAPICommunicator : PlaceAPICommunicator

- (BOOL)wasAskedToFetchPlaces;

@end
