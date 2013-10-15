//
//  SkylineFetcherDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SkylineDataFetcherDelegate <NSObject>

- (void)didReceiveSkylinePoints:(NSArray *)skylinePoints forOverlook:(NSInteger)overlookID;
- (void)fetchingSkylinePointsFailedWithError:(NSError *)error;

@end
