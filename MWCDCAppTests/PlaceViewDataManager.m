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
    // set up regex once for search query
    NSError *error = NULL;
    NSString *pattern = [NSString stringWithFormat:@"\\b%@", self.filterQuery];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    // only bother filters if places or query exist
    NSMutableArray *filteredPlaces = [NSMutableArray array];
    for (Place *place in self.places) {
        BOOL matchesCategory = YES;
        if (self.filterCategory != nil) {
            matchesCategory = ([place.categoryLabel isEqualToString:self.filterCategory]);
        }
        
        // if it's not a match, don't bother with expensive regex search
        if (!matchesCategory) {
            continue;
        }
        
        BOOL matchesSearch = YES;
        
        if (self.filterQuery != nil && self.filterQuery.length) {
            NSString *searchText = [NSString stringWithFormat:@"%@ %@ %@", place.name, place.streetAddress, place.description];
            NSRange textRange = NSMakeRange(0, searchText.length);
            NSRange matchRange = [regex rangeOfFirstMatchInString:searchText
                                                          options:NSMatchingReportProgress
                                                            range:textRange];
            matchesSearch = (matchRange.location != NSNotFound);
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
