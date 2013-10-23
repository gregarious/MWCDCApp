//
//  PlaceTableViewCell.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/11/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@class Place;

@interface PlaceTableViewCell : UITableViewCell

// this is only to be a container for use in the TableVC segue. No guarantee this
// reference matches any subview properties!!!
@property (nonatomic, weak) Place *place;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet AsyncImageView *thumbnail;

@end
