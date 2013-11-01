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

/* private */
- (void)configureView {
    if (self.place && self.nameLabel) {
        self.nameLabel.text = self.place.name;
        self.addressLabel.text = self.place.streetAddress;
        self.descriptionLabel.text = @"Literally mollit tousled 8-bit Tonx qui pork belly occupy lomo, ethnic dreamcatcher umami chia vero magna. Exercitation ea kale chips, readymade asymmetrical Brooklyn post-ironic reprehenderit iPhone minim fanny pack ex before they sold out. Labore sustainable cred, sartorial vero pour-over kale chips Blue Bottle cliche selvage post-ironic retro plaid aliqua Bushwick. Delectus pickled magna commodo Etsy wolf viral, fap sriracha irony. Ullamco pop-up mumblecore, cupidatat Godard vegan art party meh non narwhal flexitarian American Apparel chillwave. Quis organic small batch, Schlitz narwhal next level cardigan officia mlkshk Godard anim bicycle rights lo-fi. Put a bird on it velit synth, 90's church-key pop-up reprehenderit +1 you probably haven't heard of them iPhone Thundercats semiotics Echo Park art party pariatur.\n\nMoo cow.";
    }
}

@end
