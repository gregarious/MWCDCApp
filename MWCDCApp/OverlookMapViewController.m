//
//  OverlookListViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Overlook.h"
#import "OverlookMapViewController.h"
#import "SkylineViewController.h"

@interface OverlookMapViewController ()

- (NSArray *)fixedOverlooks;
- (void)setViewContentForOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation OverlookMapViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    overlooks = [self fixedOverlooks];
    
    self.mapView.scrollEnabled = NO;
    [self.mapView addAnnotations:overlooks];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setViewContentForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewContentForOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        overlayImage.hidden = YES;
        self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.435136, -80.010681), 3000, 3000);
    }
    else {
        overlayImage.hidden = NO;
        self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.435136, -80.010681), 2500, 2500);
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // show slight variations of the overlook map depending on device orienttaion
    [self setViewContentForOrientation:toInterfaceOrientation];
}

#pragma mark - MKMapViewDelegate methods

NSString * const overlookAnnotationReuseIdentifier = @"OverlookAnnotation";


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // use the default annotation for current location
    if (annotation == mapView.userLocation){
        return nil;
    }

    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:overlookAnnotationReuseIdentifier];
    if (view == nil) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                            reuseIdentifier:overlookAnnotationReuseIdentifier];
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
    [self performSegueWithIdentifier:skylineSegueIdentifier sender:view];
}

#pragma mark - SkylineView segue
NSString * const skylineSegueIdentifier = @"showSkyline";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:skylineSegueIdentifier]) {
        SkylineViewController *skylineVC = [segue destinationViewController];
        MKAnnotationView *annotationView = sender;
        skylineVC.overlook = annotationView.annotation;
    }
}

#pragma mark - Private methods
- (NSArray *)fixedOverlooks;
{
    // this data is hardcoded on the server -- the ID must be matched manually
    
    Overlook *mon = [[Overlook alloc] initWithId:1
                                            name:@"Mon Incline"
                                         address:nil
                                      coordinate:CLLocationCoordinate2DMake(40.431647, -80.006502)];
    mon.skylineImage = [UIImage imageNamed:@"Grandview_Panorama1"];

    Overlook *duq = [[Overlook alloc] initWithId:2
                                            name:@"Duquesne Incline"
                                         address:nil
                                      coordinate:CLLocationCoordinate2DMake(40.438477, -80.019465)];
    duq.skylineImage = [UIImage imageNamed:@"Mount-Washington"];

    Overlook *wabash = [[Overlook alloc] initWithId:3
                                               name:@"Wabash Overlook"
                                            address:nil
                                         coordinate:CLLocationCoordinate2DMake(40.433733, -80.010225)];
    wabash.skylineImage = [UIImage imageNamed:@"Grandview_Panorama2"];

    Overlook *mccardle = [[Overlook alloc] initWithId:4
                                                 name:@"McCardle Overlook"
                                              address:nil
                                           coordinate:CLLocationCoordinate2DMake(40.434513, -80.011293)];
    mccardle.skylineImage = [UIImage imageNamed:@"McCardle_Panorama1"];

    return @[duq, wabash, mccardle, mon];
}

@end
