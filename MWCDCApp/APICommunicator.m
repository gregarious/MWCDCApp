//
//  APICommunicator.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "APICommunicator.h"

NSString * const PLACES_URL = @"http://mwcdc.scenable.com/api/places/";
NSString * const APICommunicatorErrorDomain = @"APICommunicatorErrorDomain";

@implementation APICommunicator

- (void)fetchPlaces {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:PLACES_URL]];

    [self initiateConnectionForRequest:request];
}

- (void)initiateConnectionForRequest:(NSURLRequest *)request {
    [self cancelAndDiscardURLConnection];
    fetchingConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    responseBuffer = [[NSMutableData alloc] init];

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain:APICommunicatorErrorDomain
                                             code:[httpResponse statusCode]
                                         userInfo:nil];

        [self.delegate searchingForPlacesFailedWithError:error];
        [self cancelAndDiscardURLConnection];
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    [responseBuffer appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    fetchingConnection = nil;
    [self.delegate searchingForPlacesFailedWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    fetchingConnection = nil;
    NSString *responseString = [[NSString alloc] initWithData:responseBuffer
                                                     encoding:NSUTF8StringEncoding];
    [self.delegate receivedPlacesJSON:responseString];
}

- (void)cancelAndDiscardURLConnection {
    [fetchingConnection cancel];
    fetchingConnection = nil;
}

@end
