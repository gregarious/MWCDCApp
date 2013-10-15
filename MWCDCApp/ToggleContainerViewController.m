//
//  SwapContainerViewController.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/15/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "ToggleContainerViewController.h"
#import "PlaceViewDataManager.h"
#import "PlaceTableViewController.h"
#import "PlaceMapViewController.h"

NSString * const ToggleMapSegueIdentifier = @"toggleMapMode";
NSString * const ToggleTableSegueIdentifier = @"toggleTableMode";

@interface ToggleContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;

@end

@implementation ToggleContainerViewController

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
    
    self.currentSegueIdentifier = ToggleTableSegueIdentifier;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *contentVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:ToggleTableSegueIdentifier])
    {
        ((PlaceTableViewController *)contentVC).dataManager = self.dataManager;
        NSLog(@"Data manager set on TableVC: %@", self.dataManager);
        // initial "toggle"
        if (self.childViewControllers.count == 0) {
            [self addChildViewController:contentVC];
            contentVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:contentVC.view];
            [contentVC didMoveToParentViewController:self];
        }
        else {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:contentVC];
        }
    }
    else if ([segue.identifier isEqualToString:ToggleMapSegueIdentifier])
    {
        ((PlaceTableViewController *)contentVC).dataManager = self.dataManager;
        NSLog(@"Data manager set on MapVC: %@", self.dataManager);
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:contentVC];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}

- (void)swapViewControllers
{
    self.currentSegueIdentifier = (self.currentSegueIdentifier == ToggleTableSegueIdentifier) ? ToggleMapSegueIdentifier : ToggleTableSegueIdentifier;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}


@end
