//
//  PlaceDetailViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "PlaceDetailContentView.h"
#import "Place.h"
#import "AsyncImageView.h"

#import <AddressBook/ABPerson.h>

@interface PlaceDetailViewController ()
{
    BOOL areContainerConstraintsSet;
}

- (void)configureView;
- (NSString *)processPhoneNumber:(NSString *)phoneNumber;
@end

@implementation PlaceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    _contentView = [[NSBundle mainBundle] loadNibNamed:@"PlaceDetailContentView"
                                                 owner:self
                                               options:nil][0];
    self.contentView.delegate = self;
    [self.scrollView addSubview:self.contentView];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _contentView = nil;
    _scrollView = nil;
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

- (void)placeDetailContainerViewCallButtonTapped:(id)view
{
    // strip spaces and parenthesis from numbers
    NSString *processedNumber = [self processPhoneNumber:self.place.phone];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", processedNumber]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)placeDetailContainerViewDirectionsButtonTapped:(id)view
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

- (void)placeDetailContainerViewFacebookButtonTapped:(id)view
{
    // TODO: hook up fb id lookup
//    // try to open with Facebook app
//    NSString* fbURL = [NSString stringWithFormat:@"fb://profile/%@", self.place.fbId];
//    BOOL fbOpened = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbURL]];
//
//    // fall back to Safari at facebook.com if that fails
//    if (!fbOpened) {
        NSString *webURL = [NSString stringWithFormat:@"http://www.facebook.com/%@", self.place.fbId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
//    }
}

- (void)placeDetailContainerViewTwitterButtonTapped:(id)view
{
    // try to open with Twitter app
    NSString* twitterURL = [NSString stringWithFormat:@"twitter://user?screen_name=%@", self.place.twitterHandle];
    BOOL twitterOpened = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterURL]];

    // fall back to Safari at twitter.com if that fails
    if (!twitterOpened) {
        NSString *webURL = [NSString stringWithFormat:@"http://twitter.com/%@", self.place.twitterHandle];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
    }
}

- (void)placeDetailContainerViewWebsiteButtonTapped:(id)view
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
    if (self.place && self.contentView) {
        // set simple properties
        self.navigationItem.title = self.place.name;
        
        self.contentView.nameLabel.text = self.place.name;
        self.contentView.addressLabel.text = self.place.streetAddress;
        self.contentView.categoryLabel.text = self.place.categoryLabel;
        self.contentView.thumbnailImage.imageURL = [NSURL URLWithString:self.place.imageURLString];
        
        // configure map view
        self.contentView.mapView.delegate = self;
        [self.contentView.mapView addAnnotation:self.place];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.place.coordinate, 500, 500);
        [self.contentView.mapView setRegion:region];
        
        // disable any buttons whose actions are unavailable
        if (self.place.phone == nil || self.place.phone.length == 0) {
            self.contentView.callButton.enabled = NO;
        }
        else {
            // set a custom phone number label
            NSString *phoneNumber = [self processPhoneNumber:self.place.phone];
            [self.contentView.callButton setTitle:phoneNumber forState:UIControlStateNormal];
        }
        
        if (self.place.fbId == nil || self.place.fbId.length == 0) {
            self.contentView.facebookButton.enabled = NO;
        }
        if (self.place.twitterHandle == nil || self.place.twitterHandle.length == 0) {
            self.contentView.twitterButton.enabled = NO;
        }
        if (self.place.website == nil || self.place.website.length == 0) {
            self.contentView.websiteButton.enabled = NO;
        }
        
        self.contentView.descriptionLabel.text = self.place.description;
        
        // add constraints, if they have not yet been set
        if (!areContainerConstraintsSet) {
            self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

            NSDictionary *viewsDictionary = @{@"scrollView": self.scrollView,
                                              @"contentView": self.contentView};
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics: 0 views:viewsDictionary]];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics: 0 views:viewsDictionary]];

            areContainerConstraintsSet = YES;
        }
        
        // in case content view doesn't fill our view height, match the background colors
        self.view.backgroundColor = self.contentView.backgroundColor;
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
