//
//  PlaceViewDataManager.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Place;

typedef NS_ENUM(NSUInteger, PlaceViewDataStatus) {
    PlaceViewDataStatusUninitialized,
    PlaceViewDataStatusInitialized,
    PlaceViewDataStatusError
};

@interface PlaceViewDataManager : NSObject

@property (nonatomic, copy) NSArray *places;
@property (nonatomic, copy) NSError *lastError;

- (Place *)placeForPosition:(NSUInteger)position;
- (PlaceViewDataStatus)dataStatus;

@end
