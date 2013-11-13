//
//  WelcomeViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/4/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController
- (IBAction)businessesButton:(id)sender;
- (IBAction)overlooksButton:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutSpaceConstraint;

@end
