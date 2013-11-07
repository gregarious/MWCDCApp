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

NSString *bigDesc = @"Literally mollit tousled 8-bit Tonx qui pork belly occupy lomo, ethnic dreamcatcher umami chia vero magna. Exercitation ea kale chips, readymade asymmetrical Brooklyn post-ironic reprehenderit iPhone minim fanny pack ex before they sold out. Labore sustainable cred, sartorial vero pour-over kale chips Blue Bottle cliche selvage post-ironic retro plaid aliqua Bushwick. Delectus pickled magna commodo Etsy wolf viral, fap sriracha irony. Ullamco pop-up mumblecore, cupidatat Godard vegan art party meh non narwhal flexitarian American Apparel chillwave. Quis organic small batch, Schlitz narwhal next level cardigan officia mlkshk Godard anim bicycle rights lo-fi. Put a bird on it velit synth, 90's church-key pop-up reprehenderit +1 you probably haven't heard of them iPhone Thundercats semiotics Echo Park art party pariatur.\nRaw denim odio artisan gentrify small batch, flexitarian butcher adipisicing mumblecore forage dolor mixtape PBR&B duis. Cray aesthetic wolf master cleanse in. Mlkshk post-ironic hashtag excepteur, mollit Marfa sed Pitchfork 90's wayfarers deep v. Forage direct trade dolor Wes Anderson Intelligentsia, placeat 90's Carles asymmetrical. 8-bit yr pickled, veniam blog ethnic gastropub brunch art party Banksy quis aliqua hella gluten-free salvia. Try-hard polaroid Odd Future vero Intelligentsia freegan. Flannel before they sold out stumptown butcher mixtape umami.\nOccaecat whatever ea, elit beard Cosby sweater keytar adipisicing actually quis fugiat Austin. Cray nesciunt Helvetica, post-ironic chia Godard sriracha est Schlitz 3 wolf moon. Yr ugh small batch synth, DIY readymade blog butcher farm-to-table proident meggings. Quis ullamco keytar, semiotics Banksy scenester voluptate mlkshk. In meggings Tonx Helvetica, dolore viral food truck beard master cleanse umami keffiyeh stumptown banjo delectus. Twee Godard before they sold out forage, vegan exercitation fashion axe master cleanse esse ut +1 Brooklyn ea semiotics nihil. Master cleanse artisan Shoreditch delectus farm-to-table, chillwave single-origin coffee irure raw denim sed cillum nihil.";

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

        self.categoryLabel.text = self.place.categoryLabel;

        self.imageView.imageURL = [NSURL URLWithString:self.place.imageURLString];
        
        self.mapView.delegate = self;
        [self.mapView addAnnotation:self.place];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.place.coordinate, 500, 500);
        [self.mapView setRegion:region];
        
        if (self.place.phone == nil || self.place.phone.length == 0) {
            self.callButton.enabled = NO;
            self.callButtonLabel.enabled = NO;
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

        // set and fit description label
        self.descriptionLabel.text = bigDesc;
        [[self descriptionLabel] sizeToFit];

        CGRect newBounds = self.contentView.bounds;
        newBounds.size.height += self.descriptionLabel.bounds.size.height;
        self.contentView.bounds = newBounds;
        self.scrollView.contentSize = newBounds.size;
        self.view.bounds = newBounds;
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
