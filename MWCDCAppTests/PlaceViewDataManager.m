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

- (NSArray *)availableCategories
{
    NSMutableSet *set = [NSMutableSet set];
    
    for(Place *p in self.places) {
        if (p.categoryLabel != nil) {
            [set addObject:p.categoryLabel];
        }
    }

    NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    return [set sortedArrayUsingDescriptors:@[d]];
}


#pragma mark - private methods

- (void)filterPlaces
{
    // only bother filters if places or query exist
    NSMutableArray *filteredPlaces = [NSMutableArray array];
    for (Place *place in self.places) {
        BOOL matchesSearch = YES;
        if (self.filterQuery != nil && self.filterQuery.length) {
            matchesSearch = ([place.name.lowercaseString rangeOfString:_filterQuery].location != NSNotFound);
        }
        
        BOOL matchesCategory = YES;
        if (self.filterCategory != nil) {
            matchesCategory = ([place.categoryLabel isEqualToString:self.filterCategory]);
        }
        
        if (matchesSearch && matchesCategory) {
            [filteredPlaces addObject:place];
        }
    }
    [self _setDisplayPlaces:filteredPlaces];

}

// internal method to ensure setting _displayPlaces is KVO compliant
- (void)_setDisplayPlaces:(NSArray *)places
{
    [self willChangeValueForKey:@"displayPlaces"];
    _displayPlaces = places;
    [self didChangeValueForKey:@"displayPlaces"];
}

@end
