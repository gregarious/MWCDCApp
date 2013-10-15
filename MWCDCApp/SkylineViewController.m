//
//  SkylineViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "SkylineViewController.h"
#import "Overlook.h"

@interface SkylineViewController ()

- (void)configureViews;

@end

@implementation SkylineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setOverlook:(Overlook *)overlook
{
    _overlook = overlook;
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

- (void)configureViews
{
    self.testLabel.text = _overlook.name;
}

@end
