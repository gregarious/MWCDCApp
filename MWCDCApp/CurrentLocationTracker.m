//
//  CurrentLocationTracker.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/2/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "CurrentLocationTracker.h"

@implementation CurrentLocationTracker

+ (CurrentLocationTracker *)sharedTracker
{
    static dispatch_once_t pred;
    static CurrentLocationTracker *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [CurrentLocationTracker new];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        if ([CLLocationManager locationServicesEnabled]) {
            [_locationManager startMonitoringSignificantLocationChanges];
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [locations lastObject];
}

@end
