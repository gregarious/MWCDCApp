//
//  SCEPlace.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SCEPlace : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *streetAddress;
@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;


@property (nonatomic, strong) UIImage *image;

- (id)initWithName:(NSString *)newName
     streetAddress:(NSString *)newAddress
        coordinate:(CLLocationCoordinate2D)newCoord;

@end
