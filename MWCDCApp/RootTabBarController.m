//
//  RootTabBarController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 12/12/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "RootTabBarController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

@end
