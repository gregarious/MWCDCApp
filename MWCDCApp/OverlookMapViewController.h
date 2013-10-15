//
//  OverlookListViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface OverlookMapViewController : UIViewController <MKMapViewDelegate>
{
    NSArray *overlooks;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
