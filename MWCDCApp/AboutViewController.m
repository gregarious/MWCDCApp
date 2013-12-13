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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // if targeting any platforms < iOS 7, the asset catalog R4 entry will be
    // ignored. As a result, we're creating a separate R4 image set and loading
    // it manually if there's a R4 resolution
    if([UIScreen mainScreen].bounds.size.height >= 481) {
        self.backgroundImage.image = [UIImage imageNamed:@"aboutR4"];
    }
}

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
            // 49+12 = 61
            _bottomLayoutSpaceConstraint.constant = 61;
        }
    }

    [self.view layoutSubviews];
}

@end
