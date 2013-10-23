//
//  PlaceDetailViewController.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface PlaceDetailViewController : UIViewController

@property (nonatomic, strong) Place *place;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
