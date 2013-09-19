//
//  NonNetworkedAPICommunicator.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "NonNetworkedAPICommunicator.h"

@implementation NonNetworkedAPICommunicator

- (void)setResponseBufferContents:(NSData *)data {
    responseBuffer = [data mutableCopy];
}

- (NSData *)responseBufferContents {
    return [responseBuffer copy];
}

- (void)initiateConnectionForRequest:(NSURLRequest *)request {
    // no-op
}

@end
