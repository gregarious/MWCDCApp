//
//  WelcomeViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (IBAction)businessButtonTapped:(id)sender;
- (IBAction)overlookButtonTapped:(id)sender;

@end
