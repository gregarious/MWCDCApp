//
//  SwapContainerViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceViewDataManager;

@interface ToggleContainerViewController : UIViewController

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;
- (void)swapViewControllers;

@property (nonatomic, strong) PlaceViewDataManager *dataManager;

@end
