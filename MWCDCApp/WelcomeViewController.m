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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // if targeting any platforms < iOS 7, the asset catalog R4 entry will be
    // ignored. As a result, we're creating a separate R4 image set and loading
    // it manually if there's a R4 resolution
    if([UIScreen mainScreen].bounds.size.height >= 481) {
        self.backgroundImage.image = [UIImage imageNamed:@"homeR4"];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        self.businessButton.hidden = YES;
        self.overlookButton.hidden = YES;
    }
    else {
        self.businessButton.hidden = NO;
        self.overlookButton.hidden = NO;
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    // fix for potential bug in iOS 7 where the bottomLayoutGuide in a UITabBarController
    // changes from 49 to 0 after the first tab is chosen

    // iOS 6 has no bottomLayoutGuide
    if ([self respondsToSelector:@selector(bottomLayoutGuide)]) {
        if (self.bottomLayoutGuide.length == 0.0) {
            // 49+12 = 61
            _bottomLayoutSpaceConstraint.constant = 61;
        }
    }
    [self.view layoutSubviews];
}

- (IBAction)businessButtonTapped:(id)sender {
    [[self tabBarController] setSelectedIndex:1];
}

- (IBAction)overlookButtonTapped:(id)sender {
    [[self tabBarController] setSelectedIndex:2];
}
@end
