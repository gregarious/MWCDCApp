//
//  OverlookNavigationController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 12/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "OverlookNavigationController.h"

@interface OverlookNavigationController ()

@end

@implementation OverlookNavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

@end
