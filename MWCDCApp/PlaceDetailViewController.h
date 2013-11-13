//
//  PlaceDetailViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "PlaceDetailActionDelegate.h"

@class Place;
@class PlaceDetailContentView;

@interface PlaceDetailViewController : UIViewController <PlaceDetailActionDelegate, MKMapViewDelegate>

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong, readonly) PlaceDetailContentView *contentView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@end
