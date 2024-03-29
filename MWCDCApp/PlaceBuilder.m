//
//  PlaceBuilder.m
//  MWCDCApp
//
//  Created by Greg Nicholas on 9/18/13.
//  Copyright (c) 2013 Scenable. All rights reserved.
//

#import "PlaceBuilder.h"
#import "Place.h"

@interface PlaceBuilder ()

- (Place *)buildPlaceFromDictionary:(NSDictionary *)placeDict;
- (BOOL)setError:(NSError **)error withCode:(NSInteger)code;

@end

@implementation PlaceBuilder

- (NSArray *)placesFromJSON: (NSString *)objectNotation
                      error: (NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonArray = [NSJSONSerialization JSONObjectWithData:unicodeNotation
                                                    options:0
                                                      error:&localError];
    if (jsonArray == nil) {
        // if nil, input was invalid JSON
        [self setError:error withCode:PlaceBuilderInvalidJSONError];
        return nil;
    }
    else if (![jsonArray isKindOfClass:[NSArray class]]) {
        // if result is a dict, fail because we expected an array
        [self setError:error withCode:PlaceBuilderIllFormedDataError];
        return nil;
    }
    
    NSArray *placesDataArray = jsonArray;
    NSMutableArray *placesArray = [[NSMutableArray alloc] initWithCapacity:[placesDataArray count]];
    
    for (int i = 0; i < [placesDataArray count]; ++i) {
        NSDictionary *placeData = placesDataArray[i];
        Place *place = [self buildPlaceFromDictionary:placeData];

        // nil will be returned if JSON is missing a required property
        if (place == nil) {
            [placesArray addObject:[NSNull null]];
        }
        else {
            [placesArray addObject:place];
        }
    }
    
    return [placesArray copy];
}

/** private **/
- (Place *)buildPlaceFromDictionary:(NSDictionary *)placeDict {
    if (placeDict[@"name"] == nil ||
        placeDict[@"street_address"] == nil ||
        placeDict[@"latitude"] == nil ||
        placeDict[@"longitude"] == nil) {
        
        return nil;
    }
    
    CLLocationCoordinate2D coord;
    if ([placeDict[@"latitude"] isEqual:[NSNull null]] || [placeDict[@"longitude"] isEqual:[NSNull null]]) {
        coord = CLLocationCoordinate2DMake(0, 0);
    }
    else {
        coord = CLLocationCoordinate2DMake([placeDict[@"latitude"] doubleValue],
                                       [placeDict[@"longitude"] doubleValue]);
    }
    
    Place *place = [[Place alloc] initWithName:placeDict[@"name"]
                                 streetAddress:placeDict[@"street_address"]
                                    coordinate:coord];

    // simple assignment for all other properties that are present
    if (placeDict[@"description"] != nil) {
        [place setDescription:placeDict[@"description"]];
    }
    if (placeDict[@"hours"] != nil) {
        [place setHours:placeDict[@"hours"]];
    }
    if (placeDict[@"fb_id"] != nil) {
        [place setFbId:placeDict[@"fb_id"]];
    }
    if (placeDict[@"twitter_handle"] != nil) {
        [place setTwitterHandle:placeDict[@"twitter_handle"]];
    }
    if (placeDict[@"phone"] != nil) {
        [place setPhone:placeDict[@"phone"]];
    }
    if (placeDict[@"website"] != nil) {
        [place setWebsite:placeDict[@"website"]];
    }
    
    if (placeDict[@"image_url"] != nil) {
        [place setImageURLString:placeDict[@"image_url"]];
    }
    
    if (placeDict[@"category_id"] != nil) {
        [place setCategoryId:[placeDict[@"category_id"] integerValue]];
    }
    if (placeDict[@"category_label"] != nil) {
        [place setCategoryLabel:placeDict[@"category_label"]];
    }
    
    return place;
}

- (BOOL)setError:(NSError **)error withCode:(NSInteger)code {
    if (error) {
        *error = [NSError errorWithDomain:PlaceBuilderErrorDomain
                                     code:code
                                 userInfo:nil];
    }
    return YES;
}


@end

NSString* const PlaceBuilderErrorDomain = @"PlaceBuilderErrorDomain";
