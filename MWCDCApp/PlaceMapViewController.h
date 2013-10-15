//
//  PlaceMapViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceDataFetcherDelegate.h"

@class PlaceViewDataManager;
@class PlaceDataFetcher;
@class PlaceTableViewCell;
@class Place;

@interface PlaceMapViewController : UIViewController <MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *_mapView;
}

@property (nonatomic, strong) PlaceViewDataManager *dataManager;

@end
