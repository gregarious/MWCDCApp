//
//  PlaceDataFetcherStore.h
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/13/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlaceDataFetcherStore <NSObject>

- (void)fetchingPlacesFailedWithError: (NSError *)error;
- (void)didReceivePlaces: (NSArray *)places;

@end
