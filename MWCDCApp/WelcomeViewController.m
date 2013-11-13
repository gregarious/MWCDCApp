//
//  WelcomeViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)businessesButton:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)overlooksButton:(id)sender {
    self.tabBarController.selectedIndex = 2;
}

- (void)viewDidLayoutSubviews
{
    // fix for potential bug in iOS 7 where the bottomLayoutGuide in a UITabBarController
    // changes from 49 to 0 after the first tab is chosen

    // iOS 6 has no bottomLayoutGuide
    if ([self respondsToSelector:@selector(bottomLayoutGuide)]) {
        if (self.bottomLayoutGuide.length == 0.0) {
            _bottomLayoutSpaceConstraint.constant = 49;
        }
    }
    [self.view layoutSubviews];
}

@end
