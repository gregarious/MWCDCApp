//
//  InterestPointDetailViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "InterestPointDetailViewController.h"
#import "InterestPoint.h"
#import "AsyncImageView.h"

@interface InterestPointDetailViewController ()

- (void)configureViews;

@end

@implementation InterestPointDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setInterestPoint:(InterestPoint *)interestPoint
{
    _interestPoint = interestPoint;
    [self configureViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)configureViews
{
    self.nameLabel.text = self.interestPoint.name;
    self.addressLabel.text = self.interestPoint.address;
    self.descriptionLabel.text = @"Literally mollit tousled 8-bit Tonx qui pork belly occupy lomo, ethnic dreamcatcher umami chia vero magna. Exercitation ea kale chips, readymade asymmetrical Brooklyn post-ironic reprehenderit iPhone minim fanny pack ex before they sold out. Labore sustainable cred, sartorial vero pour-over kale chips Blue Bottle cliche selvage post-ironic retro plaid aliqua Bushwick.";
    
    self.imageView.imageURL = [NSURL URLWithString:@"http://placehold.it/60x60"];
    
    self.navigationItem.title = self.interestPoint.name;
}

@end
