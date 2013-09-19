//
//  InspectablePlaceAPICommunicator.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "InspectableAPICommunicator.h"

@implementation InspectableAPICommunicator

- (NSURLConnection *)currentURLConnection {
    return fetchingConnection;
}

- (NSMutableData *)currentResponseBuffer {
    return responseBuffer;
}


@end
