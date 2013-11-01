//
//  InterestPointDetailViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/14/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InterestPoint;
@class AsyncImageView;

@interface InterestPointDetailViewController : UIViewController

@property (nonatomic, weak) InterestPoint *interestPoint;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet AsyncImageView *imageView;

@end
