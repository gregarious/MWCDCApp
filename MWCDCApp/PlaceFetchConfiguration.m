//
//  PlaceFetchConfiguration.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/11/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceFetchConfiguration.h"
#import "PlaceDataManager.h"
#import "PlaceBuilder.h"
#import "APICommunicator.h"

@implementation PlaceFetchConfiguration

- (PlaceDataManager *)dataManager {
    PlaceDataManager *manager = [[PlaceDataManager alloc] init];
    manager.communicator = [[APICommunicator alloc] init];
    manager.placeBuilder = [[PlaceBuilder alloc] init];
    
    return manager;
}

@end
