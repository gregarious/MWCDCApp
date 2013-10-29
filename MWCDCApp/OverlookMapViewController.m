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
    
    MKCoordinateRegion initRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.436136, -80.010681), 2500, 2500);
    
    [self.mapView setRegion:initRegion];
    [self.mapView addAnnotations:overlooks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate methods

NSString * const overlookAnnotationReuseIdentifier = @"OverlookAnnotation";


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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
    Overlook *duquesne = [[Overlook alloc] initWithId:1
                                                 name:@"Duquesne Incline"
                                           coordinate:CLLocationCoordinate2DMake(40.438406, -80.019500)];
    duquesne.skylineImage = [UIImage imageNamed:@"Skyline_dev"];
    
    Overlook *mon = [[Overlook alloc] initWithId:2
                                            name:@"Monongahela Incline"
                                      coordinate:CLLocationCoordinate2DMake(40.431383, -80.006111)];
    mon.skylineImage = [UIImage imageNamed:@"Skyline_dev"];
    
    return @[duquesne, mon];
}

@end
