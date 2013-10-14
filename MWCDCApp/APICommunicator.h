//
//  APICommunicator.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICommunicatorDelegate.h"

@interface APICommunicator : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSURLConnection *fetchingConnection;
    NSMutableData *responseBuffer;
}

@property (nonatomic, weak) id<APICommunicatorDelegate> delegate;

- (void)fetchPlaces;
- (void)fetchInterestPoints:(NSUInteger)overlookID;

- (void)initiateConnectionForRequest:(NSURLRequest *)request;
- (void)cancelAndDiscardURLConnection;

@end

extern NSString * const APICommunicatorErrorDomain;
