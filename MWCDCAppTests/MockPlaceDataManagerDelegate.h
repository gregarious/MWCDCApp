//
//  MockPlaceDataManagerDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceDataManagerDelegate.h"

@interface MockPlaceDataManagerDelegate : NSObject <PlaceDataManagerDelegate>

@property (nonatomic, strong) NSError* fetchError;
@property (nonatomic, strong) NSArray* receivedPlaces;

@end
