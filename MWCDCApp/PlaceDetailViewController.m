//
//  PlaceDetailViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "Place.h"

@interface PlaceDetailViewController ()
- (void)configureView;
@end

@implementation PlaceDetailViewController

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
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPlace:(Place *)newPlace
{
    if (_place != newPlace) {
        _place = newPlace;
    }
    [self configureView];
}

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // use the default annotation for current location
    if (annotation == mapView.userLocation){
        return nil;
    }
    
    static NSString *reuseId = @"DetailPin";
    return [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                           reuseIdentifier:reuseId];
}

- (void)callButtonTapped:(id)sender
{
    NSLog(@"Calling %@", self.place.phone);
}

- (void)directionsButtonTapped:(id)sender
{
    NSLog(@"Directions to %@", self.place.streetAddress);
}

- (IBAction)facebookButtonTapped:(id)sender {
    NSLog(@"Opening Facebook for profile '%@'", self.place.fbId);
}

- (IBAction)twitterButtonTapped:(id)sender {
    NSLog(@"Opening Twitter for handle '%@'", self.place.twitterHandle);
}

- (IBAction)websiteButtonTapped:(id)sender {
    NSLog(@"Opening %@", self.place.website);
}

/* private */
- (void)configureView {
    if (self.place && self.nameLabel) {
        self.navigationItem.title = self.place.name;
        
        self.nameLabel.text = self.place.name;
        self.addressLabel.text = self.place.streetAddress;
        self.descriptionLabel.text = self.place.description;
        self.categoryLabel.text = self.place.categoryLabel;
        
        self.imageView.imageURL = [NSURL URLWithString:self.place.imageURLString];
        
        self.mapView.delegate = self;
        [self.mapView addAnnotation:self.place];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.place.coordinate, 500, 500);
        [self.mapView setRegion:region];
        
        if (self.place.phone == nil || self.place.phone.length == 0) {
            self.callButton.enabled = NO;
        }
        if (self.place.streetAddress == nil || self.place.streetAddress.length == 0) {
            self.directionsButton.enabled = NO;
        }
        if (self.place.fbId == nil || self.place.fbId.length == 0) {
            self.facebookButton.enabled = NO;
        }
        if (self.place.twitterHandle == nil || self.place.twitterHandle.length == 0) {
            self.twitterButton.enabled = NO;
        }
        if (self.place.website == nil || self.place.website.length == 0) {
            self.websiteButton.enabled = NO;
        }
    }
}

@end
