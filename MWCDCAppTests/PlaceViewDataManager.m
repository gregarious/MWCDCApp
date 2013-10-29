//
//  PlaceViewDataManager.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/19/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceViewDataManager.h"
#import "Place.h"
#import "PlaceTableViewCell.h"

@interface PlaceViewDataManager ()
- (void)_setDisplayPlaces:(NSArray *)places;
- (void)filterPlaces;
@end

@implementation PlaceViewDataManager

- (void)setPlaces:(NSArray *)places
{
    _places = [places copy];
    [self filterPlaces];
}

- (PlaceViewDataStatus)dataStatus
{
    if (self.lastError) {
        return PlaceViewDataStatusError;
    }
    else if (self.places) {
        return PlaceViewDataStatusInitialized;
    }
    else {
        return PlaceViewDataStatusUninitialized;
    }
}

- (void)setFilterQuery:(NSString *)filterQuery
{
    _filterQuery = filterQuery;
    [self filterPlaces];
}

- (void)setFilterCategory:(NSString *)filterCategory
{
    _filterCategory = filterCategory;
    [self filterPlaces];
}


#pragma mark - private methods

- (void)filterPlaces
{
    // only bother filters if places or query exist
    if (self.places.count > 0 && self.filterQuery != nil && self.filterQuery.length > 0) {
        NSMutableArray *filteredPlaces = [NSMutableArray array];
        for (Place *place in self.places) {
            if ([place.name.lowercaseString rangeOfString:_filterQuery].location != NSNotFound) {
                [filteredPlaces addObject:place];
            }
        }
        [self _setDisplayPlaces:filteredPlaces];
    }
    else {
        [self _setDisplayPlaces:[self.places copy]];
    }
}

// internal method to ensure setting _displayPlaces is KVO compliant
- (void)_setDisplayPlaces:(NSArray *)places
{
    [self willChangeValueForKey:@"displayPlaces"];
    _displayPlaces = places;
    [self didChangeValueForKey:@"displayPlaces"];
}

@end
