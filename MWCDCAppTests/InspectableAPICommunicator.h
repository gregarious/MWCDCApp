//
//  InspectablePlaceAPICommunicator.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "APICommunicator.h"

@interface InspectableAPICommunicator : APICommunicator

- (NSURLConnection *)currentURLConnection;
- (NSMutableData *)currentResponseBuffer;

@end
