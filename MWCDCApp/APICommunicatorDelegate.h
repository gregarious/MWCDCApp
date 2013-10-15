//
//  APICommunicatorDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APICommunicator;

@protocol APICommunicatorDelegate <NSObject>

- (void)fetchingDataFailedWithError:(NSError *)err;
- (void)receivedDataJSON:(NSString *)objectNotation;

@end
