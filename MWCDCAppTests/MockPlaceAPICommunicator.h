//
//  MockPlaceAPICommunicator.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICommunicator.h"

@interface MockPlaceAPICommunicator : APICommunicator

- (BOOL)wasAskedToFetchPlaces;

@end
