//
//  PlaceTableViewCell.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 10/11/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "Place.h"

@implementation PlaceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)prepareForReuse
{
    self.nameLabel.text = nil;
    self.addressLabel.text = nil;
    self.categoryLabel.text = nil;
    self.thumbnail.imageURL = nil;
}

@end
