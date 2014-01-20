//
//  Overlook.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Overlook : NSObject <MKAnnotation>

@property (nonatomic, readonly, assign) NSInteger _id;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *address;
@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) UIImage *skylineImage;

- (id)initWithId:(NSInteger)_id name:(NSString *)name
         address:(NSString *)address
      coordinate:(CLLocationCoordinate2D)coord;

// alias for name/address property (for MKAnnotation)
- (NSString *)title;
- (NSString *)subtitle;

@end
