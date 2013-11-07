//
//  PlaceDetailActionDelegate.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 11/7/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlaceDetailActionDelegate <NSObject>

- placeDetailContainerViewCallButtonTapped:(PlaceDetailContainerView *)view;
- placeDetailContainerViewDirectionsButtonTapped:(PlaceDetailContainerView *)view;
- placeDetailContainerViewFacebookButtonTapped:(PlaceDetailContainerView *)view;
- placeDetailContainerViewTwitterButtonTapped:(PlaceDetailContainerView *)view;
- placeDetailContainerViewWebsiteButtonTapped:(PlaceDetailContainerView *)view;

@end
