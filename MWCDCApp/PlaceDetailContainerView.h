//
//  PlaceDetailContainerView.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapView;
@class AsyncImageView;
@protocol PlaceDetailActionDelegate;

@interface PlaceDetailContainerView : UIView

@property (weak, nonatomic) id<PlaceDetailActionDelegate> delegate;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet AsyncImageView *thumbnailImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *callButtonLabel;

- (IBAction)callTapped:(id)sender;
- (IBAction)directionsTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
- (IBAction)twitterTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;

@end
