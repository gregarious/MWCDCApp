//
//  PlaceDetailViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "Place.h"
#import <AddressBook/ABPerson.h>

@interface PlaceDetailViewController ()
- (void)configureView;
- (NSString *)processPhoneNumber:(NSString *)phoneNumber;
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

- (IBAction)callButtonTapped:(id)sender
{
    // strip spaces and parenthesis from numbers
    NSString *processedNumber = [self processPhoneNumber:self.place.phone];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", processedNumber]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)directionsButtonTapped:(id)sender
{
    // create MKPlacemark
    NSMutableDictionary *addressDict;
    addressDict[(NSString *)kABPersonAddressStreetKey] = self.place.streetAddress;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.place.coordinate addressDictionary:addressDict];
    
    // use placemark to create item to route directions to in Maps
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.place.name;
    
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
}

- (IBAction)facebookButtonTapped:(id)sender {
    // try to open with Facebook app
    NSString* fbURL = [NSString stringWithFormat:@"fb://profile/%@", self.place.fbId];
    BOOL fbOpened = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbURL]];

    // fall back to Safari at facebook.com if that fails
    if (!fbOpened) {
        NSString *webURL = [NSString stringWithFormat:@"http://www.facebook.com/%@", self.place.fbId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
    }
}

- (IBAction)twitterButtonTapped:(id)sender {
    // try to open with Twitter app
    NSString* twitterURL = [NSString stringWithFormat:@"twitter://user?screen_name=%@", self.place.twitterHandle];
    BOOL twitterOpened = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterURL]];

    // fall back to Safari at twitter.com if that fails
    if (!twitterOpened) {
        NSString *webURL = [NSString stringWithFormat:@"http://twitter.com/%@", self.place.twitterHandle];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
    }
}

- (IBAction)websiteButtonTapped:(id)sender
{
    // ensure url has 'http' protocol
    NSString *urlString = self.place.website;
    if (![[urlString substringToIndex:4] isEqualToString:@"http"]) {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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
            self.callButtonLabel.text = @"Unknown number";
        }
        else {
            self.callButtonLabel.text = [self processPhoneNumber:self.place.phone];
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

- (NSString *)processPhoneNumber:(NSString *)phoneNumber
{
    NSMutableString *mutablePhoneNumber = [NSMutableString stringWithString:phoneNumber];
    
    [mutablePhoneNumber replaceOccurrencesOfString:@" "
                                        withString:@"-"
                                           options:NSLiteralSearch
                                             range:NSMakeRange(0, mutablePhoneNumber.length)];
    [mutablePhoneNumber replaceOccurrencesOfString:@"("
                                        withString:@""
                                           options:NSLiteralSearch
                                             range:NSMakeRange(0, mutablePhoneNumber.length)];
    [mutablePhoneNumber replaceOccurrencesOfString:@")"
                                        withString:@""
                                           options:NSLiteralSearch
                                             range:NSMakeRange(0, mutablePhoneNumber.length)];
    return mutablePhoneNumber;
}

@end
