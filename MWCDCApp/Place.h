//
//  SCEPlace.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Place : NSObject <MKAnnotation>

// Mandatory properties
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *streetAddress;
@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;

// Optional properties
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *fbId;
@property (nonatomic, copy) NSString *twitterHandle;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *category;

- (id)initWithName:(NSString *)newName
     streetAddress:(NSString *)newAddress
        coordinate:(CLLocationCoordinate2D)newCoord;

// MKAnnotation protocol methods
- (NSString *)title;

@end
