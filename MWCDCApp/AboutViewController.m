//
//  AboutViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidLayoutSubviews
{
    // fix for potential bug in iOS 7 where the bottomLayoutGuide in a UITabBarController
    // changes from 49 to 0 after the first tab is chosen
    
    // iOS 6 has no bottomLayoutGuide
    if ([self respondsToSelector:@selector(bottomLayoutGuide)]) {
        if (self.bottomLayoutGuide.length == 0.0) {
            // 49+12 = 61. no contentView here, so we need a 12pt buffer at the bottom
            _bottomLayoutSpaceConstraint.constant = 61;
        }
    }

    [self.view layoutSubviews];
}

@end
