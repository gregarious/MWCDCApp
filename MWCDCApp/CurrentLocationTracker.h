//
//  CurrentLocationTracker.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/2/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocationTracker : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@property (nonatomic, strong, readonly) CLLocation *location;

+ (CurrentLocationTracker *)sharedTracker;

@end
