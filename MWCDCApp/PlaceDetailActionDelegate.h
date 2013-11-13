//
//  PlaceDetailActionDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlaceDetailContentView;

@protocol PlaceDetailActionDelegate <NSObject>

@optional
- (void)placeDetailContainerViewCallButtonTapped:(PlaceDetailContentView *)view;
- (void)placeDetailContainerViewDirectionsButtonTapped:(PlaceDetailContentView *)view;
- (void)placeDetailContainerViewFacebookButtonTapped:(PlaceDetailContentView *)view;
- (void)placeDetailContainerViewTwitterButtonTapped:(PlaceDetailContentView *)view;
- (void)placeDetailContainerViewWebsiteButtonTapped:(PlaceDetailContentView *)view;

@end
