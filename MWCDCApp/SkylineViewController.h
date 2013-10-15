//
//  SkylineViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Overlook;

@interface SkylineViewController : UIViewController

@property (nonatomic, strong) Overlook *overlook;

@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end
