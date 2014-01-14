//
//  PlaceMapViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceMapViewController.h"
#import "PlaceViewDataManager.h"
#import "PlaceDataStore.h"
#import "PlaceDetailViewController.h"
#import "PlaceCollectionViewController.h"

@interface PlaceMapViewController ()
{
    BOOL isObservingManagerData;
}
- (void)startObservingManagerData;
- (void)stopObservingManagerData;
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
    
    CLLocationCoordinate2D center;
    CLLocationDistance meterRadius;
    
    // TODO: if smarter location-based region is needed, use the CurrentLocationTracker
    //       here to help find a better initial region
    
    center = CLLocationCoordinate2DMake(40.432136, -80.012980),
    meterRadius = 2500;
    
    MKCoordinateRegion initRegion = MKCoordinateRegionMakeWithDistance(center, meterRadius, meterRadius);
    
    [_mapView setRegion:initRegion];

    _mapView.delegate = self;
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO: observation start/stop feels a little spaghetti-ish due to the
    //  intederminate ordering of the manager setting and view display. Look into
    //  verifying correctness and refactoring
    [super viewWillAppear:animated];
    [self startObservingManagerData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopObservingManagerData];
    [super viewDidDisappear:animated];
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
    // use the default annotation for current location
    if (annotation == mapView.userLocation){
        return nil;
    }

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

#pragma mark - View syncing to data manager

- (void)setDataManager:(PlaceViewDataManager *)dataManager
{
    _dataManager = dataManager;
    [self reloadData];
    [self startObservingManagerData];
}

// observe the manager's `displayPlaces` property
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"displayPlaces"]) {
        [self reloadData];
    }
}

#pragma mark - Private methods

// naive mirroring of UITableView reloadData
- (void)reloadData
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:self.dataManager.displayPlaces];
}


- (void)startObservingManagerData
{
    if (_dataManager != nil && !isObservingManagerData) {
        isObservingManagerData = YES;
        
        // watch the displayPlaces property
        [_dataManager addObserver:self
                       forKeyPath:@"displayPlaces"
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
    }
}

- (void)stopObservingManagerData
{
    isObservingManagerData = NO;
    [_dataManager removeObserver:self forKeyPath:@"displayPlaces"];
}

@end
