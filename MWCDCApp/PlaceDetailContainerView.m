//
//  PlaceDetailContainerView.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceDetailContainerView.h"
#import "PlaceDetailActionDelegate.h"

@implementation PlaceDetailContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)callTapped:(id)sender {
    [self.delegate placeDetailContainerViewCallButtonTapped:self];
}

- (IBAction)directionsTapped:(id)sender {
    [self.delegate placeDetailContainerViewDirectionsButtonTapped:self];
}

- (IBAction)facebookTapped:(id)sender {
    [self.delegate placeDetailContainerViewFacebookButtonTapped:self];
}

- (IBAction)twitterTapped:(id)sender {
    [self.delegate placeDetailContainerViewTwitterButtonTapped:self];
}

- (IBAction)websiteTapped:(id)sender {
    [self.delegate placeDetailContainerViewWebsiteButtonTapped:self];
}
@end
