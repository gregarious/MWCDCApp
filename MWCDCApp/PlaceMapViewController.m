//
//  PlaceMapViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceMapViewController.h"
#import "PlaceViewDataManager.h"
#import "PlaceDataFetcher.h"
#import "PlaceDetailViewController.h"
#import "PlaceCollectionViewController.h"

@interface PlaceMapViewController ()

@end

@implementation PlaceMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateRegion initRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.436136, -80.010681), 2500, 2500);
    
    [_mapView setRegion:initRegion];
    _mapView.delegate = self;

    // TODO: need to handle when data manager isn't set up. also when places not set yet.
    [_mapView addAnnotations:self.dataManager.places];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate methods

NSString * const placeAnnotationReuseIdentifier = @"PlaceAnnotation";

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = [_mapView dequeueReusableAnnotationViewWithIdentifier:placeAnnotationReuseIdentifier];
    if (view == nil) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:placeAnnotationReuseIdentifier];
        view.enabled = YES;
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else {
        view.annotation = annotation;
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // TODO: obviously parent.parent is not optimal
    PlaceCollectionViewController *placeCollectionRootVC = (PlaceCollectionViewController *)self.parentViewController.parentViewController;
    [placeCollectionRootVC performSegueWithIdentifier:@"showPlaceDetail" sender:view];
}


@end
